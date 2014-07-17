module ImageGather

#  if Rails.env == "Production"
    require 'RMagick'
#  end
  
require 'amazon/ecs'

TOP_N = 8          # Number of swatches
MATCH_LOW = 75
MATCH_MED = 60
MATCH_HIGH = 70

associate_tag = "betmen-20"
access_key_id = "AKIAIZB4FOIQ27OYEB2Q"
secret_key_id = "bYNOSjzYWJvoNRpzWltEPvXhWka8Eft3n/OV0u46"

Amazon::Ecs.options = {
  :associate_tag => associate_tag,
  :AWS_access_key_id => access_key_id,       
  :AWS_secret_key => secret_key_id
}


  def hex_distance(hex_1, hex_2)

    colorObject = Struct.new(:red, :green, :blue)
    rd = hex_1[1,2].hex
    grn = hex_1[3,2].hex
    blu = hex_1[5,2].hex
    x = colorObject.new(rd, grn, blu)
    
    rd = hex_2[1,2].hex
    grn = hex_2[3,2].hex
    blu = hex_2[5,2].hex
    y = colorObject.new(rd, grn, blu)

    return ((x.red-y.red)**2 + (x.green - y.green)**2 + (x.blue - y.blue)**2)**(0.5)
  end
  
  # Create a 1-row image that has a column for every color in the quantized
  # image. The columns are sorted decreasing frequency of appearance in the
  # quantized image.
  def sort_by_decreasing_frequency(img)
    hist = img.color_histogram
    # sort by decreasing frequency
    sorted = hist.keys.sort_by {|p| -hist[p]}
    new_img = Magick::Image.new(hist.size, 1)
    new_img.store_pixels(0, 0, hist.size, 1, sorted)
  end
  
  def color_distance(x, y)
    return ((x.red-y.red)**2 + (x.green - y.green)**2 + (x.blue - y.blue)**2)**(0.5)
  end
  
  def there_is_a_match(sample, master)
    # put equation here for checking similarity
    # ((r2 - r1)2 + (g2 - g1)2 + (b2 - b1)2)1/2
    return hex_distance(sample, master) < MATCH_HIGH
      
  end

  def get_pix(img, item, color)
    palette = Magick::ImageList.new
    pixels = img.get_pixels(0, 0, img.columns, 1)
    pixels.each do |p|
      k = p.to_color(Magick::AllCompliance, false, 8, true).to_s
      puts p.to_color(Magick::AllCompliance, false, 8, true)
      puts rd = k[1,2].hex
      puts grn = k[3,2].hex
      puts blu = k[5,2].hex
      puts "end"
      #ColorObject = Struct.new(:red, :green, :blue)

      #color_object_sample = ColorObject.new(rd, grn, blu)
      #color_object_master = ColorObject.new("00".hex, "00".hex, "80".hex)

      hex_sample = k
      hex_master = color #navy blue
      # put in nested loop to go through each of the palette's colors
      if there_is_a_match(hex_sample, hex_master)
        puts "we have a match"
        link_url = "http://www.amazon.com/dp/" + item.get('ASIN') + "/?tag=betmen-20"
        @item_info << {
          :link_url => link_url,
          :image_url => item.get_hash('LargeImage')["URL"],
          :product_price => item.get('ItemAttributes/ListPrice/FormattedPrice'),
          :name => item.get('ItemAttributes/Title')
        }
        break
      end
    end
  end

  # make a query to get the total number of pages
  def search_for_products(apparel_type, color, hex_color)
    search_term = 'mens ' + color + ' ' + apparel_type
    
    res = Amazon::Ecs.item_search(search_term, {:response_group => 'Medium', :search_index => 'Apparel'})
    @item_info = []
  
    num_pages = [res.total_pages, 5].min
    
    for i in 0..num_pages

      # get each page
      res = Amazon::Ecs.item_search(search_term, {:response_group => 'Medium', :search_index => 'Apparel', :item_page => i})
  
      res.items.each do |item|
        # get first response image url
        unless item.get_hash('MediumImage').nil?
          url = item.get_hash('MediumImage')["URL"]
          #url = "http://ecx.images-amazon.com/images/I/41780xlzrtL._SR38,50_.jpg"
          #read the url of the product 
          original = Magick::Image.read(url).first

          # reduce number of colors
          quantized = original.quantize(TOP_N, Magick::RGBColorspace)

          # Create an image that has 1 pixel for each of the TOP_N colors.
          normal = sort_by_decreasing_frequency(quantized)
          get_pix(normal, item, hex_color)
        end #end unless loop
      end #end res.items.each block
      sleep(1.1) #wait 1 second to comply with Amazon reqeusts-per-second...
    end #end for
    return @item_info
  end #end search_for_products
end #end module

# DONE #TODO: convert colors into rgb values, for each item -- split the string into three strings and run "ff".hex on each
# DONE TODO: determien what is 'close enough' for color similarities -- compare the rgb to another color -- maybe a distance of 20? 30?
# DONE TODO: compare 'closeness' of colors to a master color in a palette, 
# DONE TODO: and store the item ASIN in an array if it is close enough
# DONE TODO: store the product as a possibility if it is close enough
# DONE TODO: capture an array of hashes (or objects) that store the item image, price, link
# DONE use: Product = Struct.new(:url, :image, :price, :other)
# DONE then, p = Product.new("http://this", "link to image", 33, "other info")
# DONE then add it to an array of objects like array<<p
# DONE need to analyze more than just the first result.
# DONE TODO: need to do multiple calls since they only send 10 results per query. use parameter :item_page
# DONE need to send back an array of results in an instance variable. maybe a struct.
# DONE TODO: abstract out the search terms - or have a variable that captures parameters like '(color) and (type of apparel)
#TODO: need to improve search performance? change variables: number of swatches, and 'match' tolerance
#TODO: make search results render faster by searching one page at a time and updating page with AJAX and stuff. pass the num_pages variable and i variable back and forth.
#TODO: add spinning gif to show it's working
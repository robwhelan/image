require 'net/http'
require 'vcard'
require 'phone'

Phoner::Phone.default_country_code = '1'

#url = URI.parse('http://www.robwhelan.info/test4')
#req = Net::HTTP::Get.new(url.to_s)
#res = Net::HTTP.start(url.host, url.port) {|http|
#  http.request(req)
#}
#
def create_contacts_from_vcards(user, vcard_file)
  cards=Vcard::Vcard.decode(vcard_file)

  cards.each do |card|

    c = user.contacts.new
    c.first_name = card.name.given
    c.last_name = card.name.family
    c.fullname = card.name.fullname
    c.save

    card.emails.each do |new_email|
      e = c.emails.new# emails
      e.email = new_email.to_s
      e.save
    end
  
    #phone
    card.telephones.each do |new_telephone|
      begin
        telephone = Phoner::Phone.parse(new_telephone.to_s)
        telephone_stripped = telephone.format("%a%n") #strips out parentheses and dashes, like seen in verizon

        t = c.phones.new
        t.phone = telephone_stripped
        t.save
      rescue
        puts 'Phone error'
      end
    end
  
  end
end
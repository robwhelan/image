require 'open-uri'
doc = Nokogiri::HTML.parse(open("http://bananarepublic.gap.com/browse/category.do?cid=47935&departmentRedirect=true#department=75"))
doc.xpath('//*[@id="tabTableOff"]').each do |node|
  puts node.keys
  puts node.values
  puts ""
end


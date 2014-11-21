require 'mechanize'
agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
agent.get "https://www.att.com/"

form = agent.page.form_with :id => "ssoLoginForm"
form.wireless_num = "cherylsedota"
form.pass = "temp4Rob"
form.checkboxes[0].value = false
form.submit

#then it goes to a second login
form = agent.page.form_with :name => "tGuardLoginForm"
form.userid = #cherylsedota
form.password = #temp4Rob
form.submit

agent.get "https://www.att.com/olam/talkBillUsageDetail.myworld?billStatementID=UncutBilled&ctn=5126992483"

#date and time
#"09/22/2014 01:06PM"  --string
agent.page.parser.xpath('//table//tr').each.at('td[1]').text

#number
agent.page.parser.xpath('//table//tr').each.at('td[2]/div/span').text

#incoming or not
agent.page.parser.xpath('//table//tr').each.at('td[3]').text

#duration
agent.page.parser.xpath('//table//tr').each.at('td[5]').text

def get_calls
    require 'mechanize'
    agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
    agent.get "http://www.verizonwireless.com/"
    puts 'got to home page'
    #form = agent.page.form_with :id => 'vgnSignInForm'
    agent.page.form.IDToken1 = '8439913627'
    agent.page.form.submit
    puts 'submitted phone number form'

    #challengequestion
    if agent.page.title == "My Verizon Secret Question"
      agent.page.form.IDToken1 = "washingtondc"
      agent.page.form.submit
    end
    puts 'submitted challenged question'

    #password
    if agent.page.title == "My Verizon Online Sign In - Verizon Wireless"
      agent.page.form.IDToken2 = ""
      agent.page.form.submit
    end
    puts 'submitted password'
    
    # this depends on the user being the 'Account Owner' in Verizon. Otherwise the session will not know how to click to select the person you want.
    agent.get ('https://wbillpay.verizonwireless.com/vzw/secure/services/myusageVoiceDetails.action')
    puts 'got to voice data page'
    #select the proper account
    agent.page.form_with(:name => 'leftnavform').selMTN="8439915656"
    agent.page.form_with(:name => 'leftnavform').submit
    puts 'updated selected device'
    
    agent.get ('https://wbillpay.verizonwireless.com/vzw/accountholder/unbilledusage/UnbilledVoiceViewAll.action')
    puts 'got to voice view all page'
    #now get all the data
    table = agent.page.search('td')

    (0..table.count).step(6) do |i|
      c = CallVerizon.new
      c.call_date = table[i].children[0].text
      c.call_time = table[i+1].children[0].text
      if table[i+2].children[0].text == "INCOMING"
        c.call_direction = "inbound"
      else
        c.call_direction = "outbound"
      end
      c.contact_number = table[i+3].children[1].attributes["title"].value
      c.call_duration = table[i+5].children[0].text
      c.save
    end
    
end #getcalls

def get_texts
    require 'mechanize'
    agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
    agent.get "http://www.verizonwireless.com/"
    puts 'got to home page'
    #form = agent.page.form_with :id => 'vgnSignInForm'
    agent.page.form.IDToken1 = '8439913627'
    agent.page.form.submit
    puts 'submitted phone number form'

    #challengequestion
    if agent.page.title == "My Verizon Secret Question"
      agent.page.form.IDToken1 = "washingtondc"
      agent.page.form.submit
    end
    puts 'submitted challenged question'

    #password
    if agent.page.title == "My Verizon Online Sign In - Verizon Wireless"
      agent.page.form.IDToken2 = ""
      agent.page.form.submit
    end
    puts 'submitted password'
    
    # this depends on the user being the 'Account Owner' in Verizon. Otherwise the session will not know how to click to select the person you want.
    agent.get ('https://wbillpay.verizonwireless.com/vzw/secure/services/myusageMsgDetails.action')
    puts 'got to text data page'
    #select the proper account
    agent.page.form_with(:name => 'leftnavform').selMTN="8439915656"
    agent.page.form_with(:name => 'leftnavform').submit
    puts 'updated selected device'
    
    agent.get ('https://wbillpay.verizonwireless.com/vzw/accountholder/unbilledusage/UnbilledMessagingViewAll.action')
    puts 'got to text view all page'
    #now get all the data
    table = agent.page.search('td')

    (0..table.count).step(6) do |i|
      t = TextVerizon.new
      t.text_date = table[i].children[0].text
      t.text_time = table[i+1].children[0].text
      if table[i+4].children[0].text == "Received"
        t.text_contact_number = table[i+3].children[1].attributes["title"].value
      elsif table[i+4].children[0].text == "Sent"
        t.text_contact_number = table[i+2].children[1].attributes["title"].value
      end
      t.text_direction = table[i+4].children[0].text
      t.save
    end
    
end #get texts
class User < ActiveRecord::Base
  require 'net/http'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :handle_phone, :handle_linked_in,
  :fullname, :first_name, :last_name, :provider, :uid, :profile_image, :token, :google_refresh_token, :google_expires_at
  # attr_accessible :title, :body
  
  has_many :touchpoints, dependent: :destroy
  has_many :call_verizons, dependent: :destroy
  has_many :email_gmails, dependent: :destroy
  has_many :linked_in_invitations, dependent: :destroy
  has_many :linked_in_messages, dependent: :destroy
  has_many :text_verizons, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :new_comms, dependent: :destroy

  acts_as_tagger

  def get_google_email
    require 'google/api_client'
    client = Google::APIClient.new
    #add something here to handle if the token is expired
    self.fresh_token
    client.authorization.access_token = self.token
    gmail = client.discovered_api('gmail')
    after_date = "after:" + 2.days.ago.to_date.to_s
    message_ids = []
    
    result = client.execute(:api_method => gmail.users.messages.list,
                            :parameters => {  'userId' => 'me',
                                              'q' => after_date + ' (in:sent OR in:personal OR in:inbox) -(in:inbox AND (label:promotions OR label:updates OR label:social)) -(label:promotions OR label:updates OR label:social)',
                                              'includeSpamTrash' => 'false'},
                            :authorization => client.authorization)
    
    message_list = JSON.parse(result.data.to_json)
    #num_pages = message_list["resultSizeEstimate"]
    next_page = message_list["nextPageToken"]

    message_list["messages"].each do |msg|
      message_ids << msg["id"]
    end

    i = 0
    while next_page != nil do
      result = client.execute(:api_method => gmail.users.messages.list,
                              :parameters => {  'userId' => 'me',
                                                'q' => after_date,
                                                'pageToken' => next_page},
                              :authorization => client.authorization)
    
      message_list = JSON.parse(result.data.to_json)
      message_list["messages"].each do |msg|
        message_ids << msg["id"]
      end

      next_page = message_list["nextPageToken"]
    end    
    
    message_ids.each do |msg|
      _id = msg
      unique_message = client.execute(:api_method => gmail.users.messages.get, :parameters => { 'userId' => 'me', 'id' => _id }, :authorization => client.authorization )
      
      h = JSON.parse(unique_message.data.to_json)["payload"]["headers"]
      header_from = h.select { |header| header["name"] == "From"}.first["value"]
      
      begin
        header_date = h.select { |header| header["name"] == "Date"}.first["value"]
        date_sent = header_date.to_datetime
        begin
          header_to = h.select { |header| header["name"] == "To"}.first["value"]
          email_to = header_to[/\<(.*?)>/,1]
          name_to = header_to[/^(.*?)\ </,-1]
        rescue NoMethodError
          email_to = nil
        end

        email_from = header_from[/\<(.*?)>/,1]
        name_from = header_from[/^(.*?)\ </,-1]
      
        if email_from == self.email
          email_direction = "outbound"
          contact_name = name_to
          contact_email = email_to
        else
          email_direction = "inbound"
          contact_name = name_from
          contact_email = email_from
        end

        email_gmail = self.email_gmails.create(
            :user_id => self.id,
            :contact_name => contact_name,
            :contact_email => contact_email,
            :date_sent => date_sent,
            :direction => email_direction
            )
      rescue NoMethodError
        puts "Message did not come with a date"
      end #begin...
      
    end #message_ids.each do |msg|
  end
  
  def get_google_calendar
    require 'google/api_client'
    calendar = client.discovered_api('calendar', 'v3')
  end

  def get_google_contacts
    base = "https://google.com/m8/feeds/contacts/default/full"
    results = "3000"
    max_results = "max-results=" + results
    access_token = "access_token=" + self.token
    params = "?" + access_token + "&" + max_results
    uri = URI(base + params)
    contacts_feed = Net::HTTP.get(uri)
    doc = Nokogiri::HTML(contacts_feed)
    
    doc.css('entry').each do |item|
  		contact = self.contacts.new

      #get image
      image_link = item.xpath('./link').first.attribute('href').value
  		contact.profile_image = image_link

      #get full name
      full_name = item.xpath('./title')[0].children.inner_text
      contact.fullname = full_name
      
      #get first and last name
      formatted_name_array = full_name.split
      if formatted_name_array.size == 2
        first_name = formatted_name_array[0]
        last_name = formatted_name_array[1]
      elsif formatted_name_array.size == 3
        first_name = formatted_name_array[0]
        last_name = formatted_name_array[2]
      elsif formatted_name_array.size == 1
        first_name = formatted_name_array[0]
      else
        first_name = formatted_name_array[0]
        last_name = formatted_name_array[-1]
      end
      contact.first_name = first_name
      contact.last_name = last_name
      contact.save
      
      #get emails
      item.xpath('./email').each do |e|
        email = contact.emails.new
        email.email = e.attributes['address'].value
        email.save
      end

      #get phones
  		item.xpath('./phonenumber').each do |p|
        phone = contact.phones.new
        phone.phone = p.children.first.text
        phone.save
      end
    end #each entry
  end #get contacts

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      user = User.find_by_email(access_token.info.email)
      if user
        user.provider = access_token.provider
        user.uid = access_token.uid
        user.token = access_token.credentials.token
        user.save
      else
        user = User.create(
          :fullname => access_token.info.name,
          :first_name => access_token.info.first_name,
          :last_name => access_token.info.last_name,
          :provider => access_token.provider,
          :uid => access_token.uid,
          :token => access_token.credentials.token,
          :google_refresh_token => access_token.credentials.refresh_token,
          :google_expires_at => Time.at(access_token.credentials.expires_at).to_datetime,
          :email => access_token.info.email,
          :password => Devise.friendly_token[0,20],
          :profile_image => access_token.info.image
          )
      end
      return user
  end

  def token_to_params
    {'refresh_token' => self.google_refresh_token,
    'client_id' => ENV['GOOGLE_CLIENT'],
    'client_secret' => ENV['GOOGLE_SECRET'],
    'grant_type' => 'refresh_token'}
  end
 
  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, self.token_to_params)
  end
 
  def token_refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    update_attributes(
      token: data['access_token'],
      google_expires_at: Time.now + (data['expires_in'].to_i).seconds)
  end
 
  def token_expired?
    google_expires_at < Time.now
  end
 
  def fresh_token
    if token_expired?
      token_refresh!
    end
    token
  end

  def recent_touchpoints(limit)
    touchpoints.order('created_at DESC').limit(limit)
  end
  
  def contacts_shown_as_actionable
    self.contacts.where(:show_as_actionable => true)
  end

  def contacts_shown_as_ignored
    self.contacts.where(:show_as_actionable => false)
  end

  def set_encrypted_vault(email_user, email_password, linked_in_username, linked_in_password, verizon_primary, verizon_secret, verizon_password, verizon_data, vault_password)

    self.encrypted_email_user =          AESCrypt.encrypt(email_user, vault_password)
    self.encrypted_email_password =      AESCrypt.encrypt(email_password, vault_password)
    self.encrypted_linked_in_username =  AESCrypt.encrypt(linked_in_username, vault_password)
    self.encrypted_linked_in_password =  AESCrypt.encrypt(linked_in_password, vault_password)
    self.encrypted_verizon_primary =     AESCrypt.encrypt(verizon_primary, vault_password)
    self.encrypted_verizon_secret =      AESCrypt.encrypt(verizon_secret, vault_password)
    self.encrypted_verizon_password =    AESCrypt.encrypt(verizon_password, vault_password)
    self.encrypted_verizon_data =        AESCrypt.encrypt(verizon_data, vault_password)
    
    self.save
      
  end  

  def get_gmail_messages(msg_direction, username, password, count_record)
    require 'gmail'

    gmail = Gmail.new(username, password)

    if (msg_direction == "outbound")
      mbox = gmail.mailbox("[Gmail]/Sent Mail")
    elsif (msg_direction == "inbound")
      mbox = gmail.inbox
    end

    messages = mbox.emails
    user = self
    @new_comms = NewComm.find(count_record)

    first_data_pull = user.email_gmails.where(:direction => msg_direction).empty?
    if first_data_pull
      newest = Date.parse("January 1, 1900")
    else
      newest = EmailGmail.newest(msg_direction, user)
    end

    if msg_direction == "outbound"
      counter = 0
      messages.last(100).each do |msg|
        if newest < msg.date
          e = user.email_gmails.new(:batch_id => count_record)
          e.date_sent = msg.date
          e.subject = msg.subject
          e.contact_email = msg.smtp_envelope_to[0] #gets recipient email
          begin
            e.contact_name = msg.header_fields[3].field.display_names[0] #gets recipient display name
          rescue NoMethodError
            e.contact_name = ""
          end
          e.direction = msg_direction
          e.message_id = msg.message.message_id
          e.save
          counter = counter+1
        else
          puts "already been downloaded"
        end #if new
      end #each message
      @new_comms.email_out = counter
      @new_comms.save
    elsif msg_direction == "inbound"
      counter = 0
      messages.last(100).each do |msg|
        if newest < msg.date
          e = user.email_gmails.new(:batch_id => count_record)
          e.date_sent = msg.date
          e.subject = msg.subject
          e.contact_email = msg.smtp_envelope_from #gets recipient email

          begin
            e.contact_name = msg.header_fields[3].field.display_names[0]
          rescue NoMethodError
            begin
              e.contact_name = msg.header_fields[6].field.display_names[0]
            rescue NoMethodError
              begin
                e.contact_name = msg.header_fields[7].field.display_names[0]
              rescue NoMethodError
                begin
                  e.contact_name = msg.header_fields[1].field.display_names[0]
                rescue NoMethodError
                  e.contact_name = ""
                end
              end
            end
          end

          e.direction = msg_direction
          e.message_id = msg.message.message_id
          e.save
          counter = counter+1
        else
          puts "already downloaded"
        end
      end #block
      @new_comms.email_in = counter
      @new_comms.save
    end #outbound / inbound

  end #get_gmail_messages

  def get_calls(phone_primary, secret_question, password, phone_data, count_record)
      require 'mechanize'
      agent = Mechanize.new#{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
      agent.get "http://www.verizonwireless.com/"
#      puts 'got to home page:'
#      puts agent.page.title

      if agent.page.title == "My Verizon Secret Question"
#        puts 'case 1'
#        puts agent.page.forms[0].action.to_s
#        puts agent.page.forms[0].fields.to_s
        agent.page.form.IDToken1 = secret_question
#        puts agent.page.title
#        puts 'My verizon secret question: submitting challenge question'
        agent.page.form.submit
#        puts 'submitted challenged question, now on page:'
#        puts agent.page.title
      elsif agent.page.title == "My Verizon Online Sign In - Verizon Wireless"
#        puts 'case 1a'
#        puts agent.page.forms[0].action.to_s
#        puts agent.page.forms[0].fields.to_s
        agent.page.forms[0].IDToken2 = password
#        puts 'about to submit password'
        agent.page.forms[0].submit
#        puts 'submitted password, now on page:'
#        puts agent.page.title
      else
#        puts 'case 2'
#        puts "not on secret question, actually on:"
#        puts agent.page.title
#        puts agent.page.forms[0].action.to_s
#        puts agent.page.forms[0].fields.to_s
        agent.page.forms[0].IDToken1 = phone_primary
        agent.page.forms[0].submit
#        puts 'submitted phone number form and it took me to:'
#        puts agent.page.title
      end
      #form = agent.page.form_with :id => 'vgnSignInForm'

      if agent.page.title == "My Verizon"
#        puts 'case 3'
#        puts agent.page.title
#        puts "My Verizon: random page title for already-logged-in"
#        puts agent.page.forms[0].action.to_s
#        puts agent.page.forms[0].fields.to_s
        agent.page.form.submit
#        puts "submitted form, now on:"
#        puts agent.page.title
      end

      if agent.page.title == "My Verizon Secret Question"
#        puts 'case 4'
        agent.page.form.IDToken1 = secret_question
#        puts agent.page.forms[0].action.to_s
#        puts agent.page.forms[0].fields.to_s
        agent.page.form.submit
#        puts 'submitted challenged question later on'
#        puts agent.page.title
      end

      #password
      if agent.page.title == "My Verizon Online Sign In - Verizon Wireless"
#        puts 'case 5'
#        puts agent.page.forms[0].action.to_s
#        puts agent.page.forms[0].fields.to_s
#        puts "entering password into IDToken2"
        agent.page.forms[0].IDToken2 = password
#        puts agent.page.forms[0].fields.to_s
#        puts 'about to submit form'
        agent.page.forms[0].submit
#        puts 'submitted password, now on page:'
#        puts agent.page.title
#        puts agent.page.forms.count
#        puts agent.page.forms[0].action.to_s
#        puts agent.page.forms[0].fields.to_s
      end
      
      if agent.page.title == "Verizon Wireless - We Never Stop Working For You" #account is locked
#        puts 'case 6'
#        puts agent.page.forms[0].action.to_s
#        puts agent.page.forms[0].fields.to_s
        agent.page.forms[0].mobileNumber = phone_primary
        agent.page.forms[0].submit
#        puts agent.page.title
#        puts agent.page.forms[0].action.to_s
#        puts agent.page.forms[0].fields.to_s
      end
      
      # this depends on the user being the 'Account Owner' in Verizon. Otherwise the session will not know how to click to select the person you want.
      
      agent.get ('https://wbillpay.verizonwireless.com/vzw/secure/services/myusageVoiceDetails.action')
#      puts 'got to voice data page'
#      puts agent.page.title
      #select the proper account
      agent.page.form_with(:name => 'leftnavform').selMTN=phone_data
      agent.page.form_with(:name => 'leftnavform').submit
#      puts 'updated selected device'
#      puts agent.page.title
    
      agent.get ('https://wbillpay.verizonwireless.com/vzw/accountholder/unbilledusage/UnbilledVoiceViewAll.action')
#      puts 'got to voice view all page'
#      puts agent.page.title
      #now get all the data
      table = agent.page.search('td')

      user = self
      @new_comms = NewComm.find(count_record)

      first_data_pull = user.call_verizons.empty?
      if first_data_pull
        newest = Date.parse("January 1, 1900")
      else
        newest = CallVerizon.newest(user)
      end

      counter_in = 0
      counter_out = 0

      (0..table.count).step(6) do |i|
        #check here about message date and newest
        begin
          dt = table[i].children[0].text
          dt=Date.strptime(dt,"%m/%d/%Y")
          tm = table[i+1].children[0].text
          date_string = DateTime.parse( "#{dt} #{tm}").to_s
          call_date = DateTime.parse(date_string)

          if newest < call_date #maybe the formats are different
            c = user.call_verizons.new(:batch_id => count_record)

            if table[i+2].children[0].text == "INCOMING"
              c.call_direction = "inbound"
              counter_in = counter_in + 1
            else
              c.call_direction = "outbound"
              counter_out = counter_out + 1
            end
            c.contact_number = table[i+3].children[1].attributes["title"].value
            c.call_duration = table[i+5].children[0].text
            c.call_date = call_date
            c.save
          end #if newer data
        rescue NoMethodError
          puts "reached end of call data"
        end
      end #stepping through data

      @new_comms.call_in = counter_in
      @new_comms.call_out = counter_out
      @new_comms.save
    
  end #getcalls

  def get_texts(phone_primary, secret_question, password, phone_data, count_record)
      require 'mechanize'
      agent = Mechanize.new#{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
      agent.get "http://www.verizonwireless.com/"
      puts 'got to home page'
      form = agent.page.form_with :id => 'vgnSignInForm'
      agent.page.forms[0].IDToken1 = phone_primary
      agent.page.forms[0].submit
      puts 'submitted phone number form'

      if agent.page.title == "My Verizon Secret Question"
        agent.page.form.IDToken1 = secret_question
        agent.page.form.submit
      end
      puts 'submitted challenged question'
      puts agent.page.title

      if agent.page.title == "My Verizon"
        agent.page.form.submit
      end

      if agent.page.title == "My Verizon Secret Question"
        agent.page.form.IDToken1 = secret_question
        agent.page.form.submit
      end
      puts 'submitted challenged question'

      if agent.page.title == "My Verizon Online Sign In - Verizon Wireless"
        agent.page.form.IDToken2 = password
        agent.page.form.submit
      end
      puts 'submitted password'
    
      # this depends on the user being the 'Account Owner' in Verizon. Otherwise the session will not know how to click to select the person you want.
      agent.get ('https://wbillpay.verizonwireless.com/vzw/secure/services/myusageMsgDetails.action')
      puts 'got to text data page'
      #select the proper account
      agent.page.form_with(:name => 'leftnavform').selMTN=phone_data
      agent.page.form_with(:name => 'leftnavform').submit
      puts 'updated selected device'
    
      agent.get ('https://wbillpay.verizonwireless.com/vzw/accountholder/unbilledusage/UnbilledMessagingViewAll.action')
      puts 'got to text view all page'
      #now get all the data
      table = agent.page.search('td')

      user = self
      @new_comms = NewComm.find(count_record)

      first_data_pull = user.text_verizons.empty?
      if first_data_pull
        newest = Date.parse("January 1, 1900")
      else
        newest = TextVerizon.newest(user)
      end

      counter_in = 0
      counter_out = 0

      (0..table.count).step(6) do |i|

        begin
          dt = table[i].children[0].text
          dt=Date.strptime(dt,"%m/%d/%Y")
          tm = table[i+1].children[0].text
          date_string = DateTime.parse( "#{dt} #{tm}").to_s
          text_date = DateTime.parse(date_string)

          if newest < text_date
            t = user.text_verizons.new(:batch_id => count_record)
            if table[i+4].children[0].text == "Received"
              t.text_contact_number = table[i+3].children[1].attributes["title"].value
              counter_in = counter_in + 1
            elsif table[i+4].children[0].text == "Sent"
              t.text_contact_number = table[i+2].children[1].attributes["title"].value
              counter_out = counter_out + 1
            end
            t.text_direction = table[i+4].children[0].text
            t.text_date = text_date
            t.save
          end # newest < text date
        rescue NoMethodError
          puts "reached end of texting data"
        end
      end # td block
      @new_comms.text_in = counter_in
      @new_comms.text_out = counter_out
      @new_comms.save      
    
  end #get texts

  def get_invitations(initiator, username, password, count_record)
      require 'mechanize'
      agent = Mechanize.new
      #{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
      agent.get "https://www.linkedin.com"
      puts "got to landing page"
      form = agent.page.form_with :name => 'login'
      form.session_key    = username
      form.session_password = password
      form.submit
      puts "submitted username and password"

      if initiator == "outbound"
        inbox_route = "sent"
      elsif initiator == "inbound"
        inbox_route = "archive"
      end

      agent.get ('https://www.linkedin.com/inbox/' + inbox_route)
      puts "got to messages page"
      #get number of pages of messages
      puts 'line 398'
      num_pages = agent.page.search('.page').text.to_s[/#{"of "}(.*?)#{"\n"}/m, 1].to_i
      user = self
      @new_comms = NewComm.find(count_record)

      first_data_pull = user.linked_in_invitations.where(:initiator => initiator).empty?
      if first_data_pull
        newest = Date.parse("January 1, 1900")
      else
        newest = LinkedInInvitation.newest(initiator, user)
      end
    
      counter = 0

      for i in 0..num_pages
        agent.page.search('.item-content').each do |invitation|
          if newest < DateTime.parse(invitation.at('.date').at('.time-millis').text)
            if (invitation.at('.detail-link').text.to_s == "\nJoin my network on LinkedIn\n" || 
                invitation.at('.detail-link').text.to_s == "\nInvitation to connect on LinkedIn\n")
                  invite = user.linked_in_invitations.new(:batch_id => count_record)
                    invite.name = invitation.at('.participants').children.last.text.strip
                    invite.date_sent = invitation.at('.date').at('.time-millis').text
                    invite.initiator = initiator

                    counter = counter + 1

                    if invitation.at('.item-status').nil?
                      invite.accepted = false
                    else
                      puts 'line 432'
                      if invitation.at('.item-status').text.to_s == "\n(Accepted)\n"
                        invite.accepted = true
                      else
                        invite.accepted = false
                      end #decided whether invite was accepted
                    end #decide if invite has a status

                  invite.save              
            else
              puts "not an invitation"
            end # if it's an invitation
          else
            puts "have already downloaded"
          end # if it has already been downloaded
        end # for each page
  
        startRow = i*10 + 1
        url = 'https://www.linkedin.com/inbox/' + inbox_route + '?startRow=' + startRow.to_s + '&subFilter=&keywords=&sortBy='
        agent.get(url)

      end #for

      if initiator == "inbound"
        @new_comms.li_invite_in = counter
      elsif initiator == "outbound"
        @new_comms.li_invite_out = counter
      end

      @new_comms.save

  end #getInvitations

  def get_messages(initiator, username, password, count_record)
      require 'mechanize'
      agent = Mechanize.new
      #{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
      agent.get "https://www.linkedin.com"

      form = agent.page.form_with :name => 'login'
      form.session_key    = username
      form.session_password = password
      form.submit

      if initiator == "outbound"
        inbox_route = "sent"
      elsif initiator == "inbound"
        inbox_route = "messages"
      end

      agent.get ('https://www.linkedin.com/inbox/' + inbox_route)

      #get number of pages of messages
      num_pages = agent.page.search('.page').text.to_s[/#{"of "}(.*?)#{"\n"}/m, 1].to_i

      user = self
      @new_comms = NewComm.find(count_record)

      first_data_pull = user.linked_in_messages.where(:initiator => initiator).empty?
      if first_data_pull
        newest = Date.parse("January 1, 1900")
      else
        newest = LinkedInMessage.newest(initiator, user)
      end

      counter = 0

      for i in 0..num_pages
      #block
        agent.page.search('.item-content').each do |message|
          if newest < DateTime.parse(message.at('.date').at('.time-millis').text)
            if (message.at('.detail-link').text.to_s == "\nJoin my network on LinkedIn\n" || 
                message.at('.detail-link').text.to_s == "\nInvitation to connect on LinkedIn\n")
                puts "this is an invite"
            else
              msg = user.linked_in_messages.new(:batch_id => count_record)
              msg.name = message.at('.participants').children.last.text.strip
              msg.date_sent = message.at('.date').at('.time-millis').text
              msg.initiator = initiator
          
              counter = counter + 1
              
              if message.at('.item-status').nil?
                msg.is_a_reply_to_outbound = false
              else
                if message.at('.item-status').text.to_s == "\n(Replied)\n"
                  msg.is_a_reply_to_outbound = true
                else
                  msg.is_a_reply_to_outbound = false
                end #replied
              end #item status nil

              msg.save
            end # msg is an invitation
          else
            puts "have already downloaded"
          end # if it has already been downloaded
        end # block for each message
        startRow = i*10 + 1
        url = 'https://www.linkedin.com/inbox/' + inbox_route + '?startRow=' + startRow.to_s + '&subFilter=&keywords=&sortBy='
        agent.get(url)

      end #for
      
      if initiator == "inbound"
        @new_comms.li_message_in = counter
      elsif initiator == "outbound"
        @new_comms.li_message_out = counter
      end

      @new_comms.save
      
  end #get_messages

end
module GetEmail
  
def get_gmail_messages(msg_direction, username, password)
  require 'gmail'

  gmail = Gmail.new(username, password)

  if (msg_direction == "outbound")
    mbox = gmail.mailbox("[Gmail]/Sent Mail")
  elsif (msg_direction == "inbound")
    mbox = gmail.inbox
  end

  messages = mbox.emails
  user = self

  first_data_pull = user.email_gmails.where(:direction => msg_direction).empty?
  if first_data_pull
    newest = Date.parse("January 1, 1900")
  else
    newest = EmailGmail.newest(msg_direction, user)
  end

  if msg_direction == "outbound"
    messages.last(100).each do |msg|
      if newest < msg.date
        e = user.email_gmails.new
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
      else
        puts "already been downloaded"
      end #if new
    end #each message
  elsif msg_direction == "inbound"
    messages.last(100).each do |msg|
      if newest < msg.date
        e = user.email_gmails.new
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
      else
        puts "already downloaded"
      end
    end #block
  end #outbound / inbound

end #get_gmail_messages

end #GetEmail
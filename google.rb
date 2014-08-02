def get_gmail_messages(msg_direction)
  require 'gmail'

  username = "whelan@gmail.com"
  password = ""
  gmail = Gmail.new(username, password)

  if (msg_direction == "outbound")
    mbox = gmail.mailbox("[Gmail]/Sent Mail")
  elsif (msg_direction == "inbound")
    mbox = gmail.inbox
  end

  messages = mbox.emails

  if msg_direction == "outbound"
    messages.last(20).each do |msg|
      e = EmailGmail.new
      e.date_sent = msg.date
      e.subject = msg.subject
      e.contact_email = msg.smtp_envelope_to[0] #gets recipient email
      e.contact_name = msg.header_fields[3].field.display_names[0] #gets recipient display name
      e.direction = msg_direction
      e.message_id = msg.message.message_id
      e.save
    end #block
  elsif msg_direction == "inbound"
    messages.last(20).each do |msg|
      e = EmailGmail.new
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
    end #block
  end #outbound / inbound

end #get_gmail_messages
module GetLinkedIn

def get_invitations(initiator, user)
    require 'mechanize'
    agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
    agent.get "https://www.linkedin.com"
    puts "got to landing page"
    form = agent.page.form_with :name => 'login'
    form.session_key    = 'whelan@gmail.com'
    form.session_password = ''
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
    num_pages = agent.page.search('.page').text.to_s[/#{"of "}(.*?)#{"\n"}/m, 1].to_i

    first_data_pull = user.linked_in_invitations.where(:initiator => initiator).empty?
    if first_data_pull
      newest = Date.parse("January 1, 1900")
    else
      newest = LinkedInInvitation.newest(initiator, user)
    end
    
    for i in 0..num_pages
      agent.page.search('.item-content').each do |invitation|
        if newest < Date.parse(invitation.at('.date').at('.time-millis').text)
          if (invitation.at('.detail-link').text.to_s == "\nJoin my network on LinkedIn\n" || 
              invitation.at('.detail-link').text.to_s == "\nInvitation to connect on LinkedIn\n")
                invite = user.linked_in_invitations.new
                  invite.name = invitation.at('.participants').children.last.text.strip
                  invite.date_sent = invitation.at('.date').at('.time-millis').text
                  invite.initiator = initiator
                  if invitation.at('.item-status').nil?
                    invite.accepted = false
                  else
                    if invitation.at('.item-status').text.to_s == "\n(Accepted)\n"
                      invite.accepted = true
                    else
                      invite.accepted = false
                    end #decided whether invite was accepted
                  end #decide if invite has a status
                invite.invitation_id = invitation.children[1].attributes["value"].value
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
end #getInvitations

def get_messages(initiator, user)
    require 'mechanize'
    agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
    agent.get "https://www.linkedin.com"

    form = agent.page.form_with :name => 'login'
    form.session_key    = 'whelan@gmail.com'
    form.session_password = ''
    form.submit

    if initiator == "outbound"
      inbox_route = "sent"
    elsif initiator == "inbound"
      inbox_route = "messages"
    end

    agent.get ('https://www.linkedin.com/inbox/' + inbox_route)

    #get number of pages of messages
    num_pages = agent.page.search('.page').text.to_s[/#{"of "}(.*?)#{"\n"}/m, 1].to_i

    first_data_pull = user.linked_in_messages.where(:initiator => initiator).empty?
    if first_data_pull
      newest = Date.parse("January 1, 1900")
    else
      newest = LinkedInMessage.newest(initiator, user)
    end

    for i in 0..num_pages
    #block
      agent.page.search('.item-content').each do |message|
        if newest < Date.parse(message.at('.date').at('.time-millis').text)
          if (message.at('.detail-link').text.to_s == "\nJoin my network on LinkedIn\n" || 
              message.at('.detail-link').text.to_s == "\nInvitation to connect on LinkedIn\n")
              puts "this is an invite"
          else
            msg = user.linked_in_messages.new
            msg.name = message.at('.participants').children.last.text.strip
            msg.date_sent = message.at('.date').at('.time-millis').text
            msg.initiator = initiator
          
            if message.at('.item-status').nil?
              msg.is_a_reply_to_outbound = false
            else
              if message.at('.item-status').text.to_s == "\n(Replied)\n"
                msg.is_a_reply_to_outbound = true
              else
                msg.is_a_reply_to_outbound = false
              end #replied
            end #item status nil
            msg.message_id = message.children[1].attributes["value"].value
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
end #get_messages

end #GetLinkedIn
#API Key:
#77m935zjd9gy37

#Secret Key:
#W0nQQ6KSSl2tzuFj

#OAuth User Token:
#95fe1852-16d7-4f8b-bef7-3337dc958b01

#OAuth User Secret:
#61c9ce0b-62f4-443f-8ad3-c86b10c5c4fc


#pin
#58070

#require 'linkedin'
# get your api keys at https://www.linkedin.com/secure/developer
#client = LinkedIn::Client.new('77m935zjd9gy37', 'W0nQQ6KSSl2tzuFj')

#request_token = client.request_token({}, :scope => "r_basicprofile")
#rtoken = request_token.token
#rsecret = request_token.secret

#pin = 58070
#client.authorize_from_request(rtoken, rsecret, pin)

#client.authorize_from_access("fa65754a-bc12-46d6-8115-6c56bac8ec69", "5d119216-c410-4b9e-a46c-aba0b4958957")
def get_invitations(initiator)
    require 'mechanize'
    agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
    agent.get "https://www.linkedin.com"

    form = agent.page.form_with :name => 'login'
    form.session_key    = 'whelan@gmail.com'
    form.session_password = 'Susannah2'
    form.submit

    if initiator == "outbound"
      inbox_route = "sent"
    elsif initiator == "inbound"
      inbox_route = "archive"
    end

    agent.get ('https://www.linkedin.com/inbox/' + inbox_route)

    #get number of pages of messages
    num_pages = agent.page.search('.page').text.to_s[/#{"of "}(.*?)#{"\n"}/m, 1].to_i

    for i in 0..num_pages
    #block
      agent.page.search('.item-content').each do |invitation|
        if (invitation.at('.detail-link').text.to_s == "\nJoin my network on LinkedIn\n" || 
            invitation.at('.detail-link').text.to_s == "\nInvitation to connect on LinkedIn\n")
          invite = LinkedInInvitation.new
            invite.name = invitation.at('.participants').children.last.text
            invite.date_sent = invitation.at('.date').at('.time-millis').text
            invite.initiator = initiator
            if invitation.at('.item-status').nil?
              invite.accepted = false
            else
              if invitation.at('.item-status').text.to_s == "\n(Accepted)\n"
                invite.accepted = true
              else
                invite.accepted = false
              end
            end
          invite.save
        else
          puts "not an invitation"
        end
      end
  
      startRow = i*10 + 1
      url = 'https://www.linkedin.com/inbox/' + inbox_route + '?startRow=' + startRow.to_s + '&subFilter=&keywords=&sortBy='
      agent.get(url)

    end #for
end #getInvitations

def get_messages(initiator)
    require 'mechanize'
    agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
    agent.get "https://www.linkedin.com"

    form = agent.page.form_with :name => 'login'
    form.session_key    = 'whelan@gmail.com'
    form.session_password = 'Susannah2'
    form.submit

    if initiator == "outbound"
      inbox_route = "sent"
    elsif initiator == "inbound"
      inbox_route = "messages"
    end

    agent.get ('https://www.linkedin.com/inbox/' + inbox_route)

    #get number of pages of messages
    num_pages = agent.page.search('.page').text.to_s[/#{"of "}(.*?)#{"\n"}/m, 1].to_i

    for i in 0..num_pages
    #block
      agent.page.search('.item-content').each do |message|
        if (message.at('.detail-link').text.to_s == "\nJoin my network on LinkedIn\n" || 
            message.at('.detail-link').text.to_s == "\nInvitation to connect on LinkedIn\n")
            puts "this is an invite"
        else
          msg = LinkedInMessage.new
          msg.name = message.at('.participants').children.last.text
          msg.date_sent = message.at('.date').at('.time-millis').text
          msg.initiator = initiator

          if message.at('.item-status').nil?
            msg.is_a_reply_to_outbound = false
          else
            if message.at('.item-status').text.to_s == "\n(Replied)\n"
              msg.is_a_reply_to_outbound = true
            else
              msg.is_a_reply_to_outbound = false
            end
          end

          msg.save
        end
      end
  
      startRow = i*10 + 1
      url = 'https://www.linkedin.com/inbox/' + inbox_route + '?startRow=' + startRow.to_s + '&subFilter=&keywords=&sortBy='
      agent.get(url)

    end #for
end #get_messages
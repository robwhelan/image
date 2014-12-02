module GoogleCalendar

  # set up the client
client = Google::APIClient.new
client.authorization.access_token = current_user.token
service = client.discovered_api('calendar', 'v3')

#https://developers.google.com/google-apps/calendar/v3/reference/calendarList/list
def getCalendarList
  page_token = nil
  result = client.execute(:api_method => service.calendar_list.list)
  while true
    entries = result.data.items
    entries.each do |e|
      print e.summary + "\n"
    end
    if !(page_token = result.data.next_page_token)
      break
    end
    result = client.execute(:api_method => service.calendar_list.list,
                            :parameters => {'pageToken' => page_token})
  end
end



end #module
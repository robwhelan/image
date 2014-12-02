module GoogleContacts
require 'net/http'

url = "https://google.com/m8/feeds/contacts/default/full"
uri = URI('http://example.com/index.html?count=10')
Net::HTTP.get(uri)
  #GET request to:
  #
  # params: ?access_token=current_user.token
  #response will be in XML

  #https://developers.google.com/google-apps/contacts/v3/#running_the_sample_code
end
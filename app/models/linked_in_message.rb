class LinkedInMessage < ActiveRecord::Base
  attr_accessible :date_sent, :initiator, :is_a_reply_to_outbound, :name
end
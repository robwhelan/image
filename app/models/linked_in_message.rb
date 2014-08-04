class LinkedInMessage < ActiveRecord::Base
  attr_accessible :date_sent, :initiator, :is_a_reply_to_outbound, :message_id, :name, :unassigned_contact
end

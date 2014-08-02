class LinkedInInvitation < ActiveRecord::Base
  attr_accessible :accepted, :date_sent, :initiator, :invitation_id, :name
end

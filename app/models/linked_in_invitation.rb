class LinkedInInvitation < ActiveRecord::Base
  attr_accessible :accepted, :date_sent, :initiator, :invitation_id, :name, :unassigned_contact
end

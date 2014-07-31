class LinkedInInvitation < ActiveRecord::Base
  attr_accessible :accepted, :date_sent, :initiator, :name
end

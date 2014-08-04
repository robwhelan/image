class Touchpoint < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user
  belongs_to :contact
  attr_accessible :direction, :name, :touchpoint_date, :touchpoint_time
end

class EmailGmail < ActiveRecord::Base
  attr_accessible :contact_email, :contact_name, :date_sent, :direction, :message_id, :subject
end

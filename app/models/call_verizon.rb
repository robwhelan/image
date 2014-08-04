class CallVerizon < ActiveRecord::Base
  attr_accessible :call_date, :call_direction, :call_duration, :call_time, :contact_number, :unassigned_contact
end

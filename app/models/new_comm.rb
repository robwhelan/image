class NewComm < ActiveRecord::Base
  attr_accessible :call_in, :call_out, :email_in, :email_out, :li_invite_in, :li_invite_out, :li_message_in, :li_message_out, :text_in, :text_out
  belongs_to :user
end

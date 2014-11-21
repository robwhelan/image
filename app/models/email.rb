class Email < ActiveRecord::Base
  belongs_to :contact
  attr_accessible :email
end

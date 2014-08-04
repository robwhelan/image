class Contact < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :city, :first_name, :handle_email, :handle_linked_in, :handle_phone, :last_name, :zip_code
  has_many :touchpoints
  
end

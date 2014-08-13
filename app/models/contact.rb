class Contact < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :city, :first_name, :handle_email, :handle_linked_in, :handle_phone, :last_name, :zip_code
  has_many :touchpoints
  has_many :call_verizons
  has_many :email_gmails
  has_many :linked_in_invitations
  has_many :linked_in_messages
  has_many :text_verizons
  belongs_to :user
  
  after_create :assign_data_points
  after_update :assign_data_points
  
  def assign_data_points
    CallVerizon.where(:contact_number => self.handle_phone).each do |e|
      set_contact_id(e)
    end
    
    TextVerizon.where(:text_contact_number => self.handle_phone).each do |e|
      set_contact_id(e)
    end

    EmailGmail.where(:contact_email => self.handle_email).each do |e|
      set_contact_id(e)
    end
  
    LinkedInInvitation.where(:name => self.handle_linked_in).each do |e|
      set_contact_id(e)
    end

    LinkedInMessage.where(:name => self.handle_linked_in).each do |e|
      set_contact_id(e)
    end
  end
  
  def set_contact_id(data)
    if data.contact_id.nil?
      data.contact_id = self.id
      data.save
    end
  end

  def create_touchpoints
    #go through all the data models to create touchpoints from them
  end
  
end

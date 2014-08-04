class Contact < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :city, :first_name, :handle_email, :handle_linked_in, :handle_phone, :last_name, :zip_code
  has_many :touchpoints
  has_many :call_verizons
  has_many :email_gmails
  has_many :linked_in_invitations
  has_many :linked_in_messages
  has_many :text_verizons
  
  after_create :assign_comm_history
  
  def assign_comm_history
    assign_data_points
    create_touchpoints
  end
  
  def assign_data_points
    CallVerizon.where(:contact_number => self.handle_phone).each do |e|
      e.contact_id = self.id
      e.save
    end
    
    TextVerizon.where(:text_contact_number => self.handle_phone).each do |e|
      e.contact_id = self.id
      e.save
    end

    EmailGmail.where(:contact_email => self.handle_email).each do |e|
      e.contact_id = self.id
      e.save
    end
  
    LinkedInInvitation.where(:name => self.handle_linked_in).each do |e|
      e.contact_id = self.id
      e.save
    end

    LinkedInMessage.where(:name => self.handle_linked_in).each do |e|
      e.contact_id = self.id
      e.save
    end
  end
  
  def create_touchpoints
    #go through all the data models to create touchpoints from them
  end
  
end

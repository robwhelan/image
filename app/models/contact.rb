class Contact < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :city, :first_name, :handle_email, :handle_linked_in, :handle_phone, :last_name, :zip_code, :show_as_actionable
  has_many :touchpoints, dependent: :destroy
  has_many :call_verizons, dependent: :destroy
  has_many :email_gmails, dependent: :destroy
  has_many :linked_in_invitations, dependent: :destroy
  has_many :linked_in_messages, dependent: :destroy
  has_many :text_verizons, dependent: :destroy
  belongs_to :user
  
  acts_as_taggable
  
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

  def most_recent_touchpoint
    self.touchpoints.order(:touchpoint_date).last
  end
  
end

class TextVerizon < ActiveRecord::Base
  attr_accessible :text_contact_number, :text_date, :text_direction, :unassigned_contact, :contact_id, :user_id, :batch_id
  belongs_to :contact
  belongs_to :user
  
  after_create :assign_contact
  after_update :create_touchpoint
  
  def assign_contact
    user = self.user
    begin
      contact = Phone.find_by_phone(self.text_contact_number).contact
    rescue
      contact = user.contacts.create
      contact.phones.create(:phone => self.text_contact_number)
    end    
    self.update_attributes(:contact_id => contact.id)
  end

  def create_touchpoint
    Touchpoint.create(
      name: 'text_message',
      direction: self.text_direction,
      touchpoint_date: self.text_date,
      subject: self,
      user: self.user,
      contact: self.contact
      )
  end

  def self.newest(user)
    ary = user.text_verizons.sort_by &:text_date
    return ary.last.text_date
  end
  
end

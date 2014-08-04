class TextVerizon < ActiveRecord::Base
  attr_accessible :text_contact_number, :text_date, :text_direction, :unassigned_contact, :contact_id, :user_id
  belongs_to :contact
  belongs_to :user
  
  after_create :assign_contact
  after_update :create_touchpoint
  
  private
  
  def assign_contact
    contact = Contact.find_by_handle_phone(self.text_contact_number)
    if contact
      self.update_attributes(:contact_id => contact.id)
      create_touchpoint
    else
      puts "contact doesn't exist yet"
    end
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

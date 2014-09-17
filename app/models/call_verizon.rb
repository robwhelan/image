class CallVerizon < ActiveRecord::Base
  attr_accessible :call_date, :call_direction, :call_duration, :contact_number, :unassigned_contact, :contact_id, :user_id, :batch_id
  belongs_to :contact
  belongs_to :user

  #after_update? wjhen a contact is created, update all these guys with a contact id? thgenb trigger a touchpoint? also, will have to create touchpoints after they are updated

  after_create :assign_contact
  after_update :create_touchpoint

  private
  
  def assign_contact
    contact = Contact.find_by_handle_phone(self.contact_number)
    if contact
      self.update_attributes(:contact_id => contact.id)
      create_touchpoint
    else
      puts "contact doesn't exist yet"
    end
  end
  
  def create_touchpoint
    Touchpoint.create(
      name: 'phone_call',
      direction: self.call_direction,
      touchpoint_date: self.call_date,
      subject_id: self.id,
      subject_type: self.class.name,
      user: self.user,
      contact: self.contact
      )
  end

  def self.newest(user)
    ary = user.call_verizons.sort_by &:call_date
    return ary.last.call_date
  end

end

class LinkedInMessage < ActiveRecord::Base
  attr_accessible :date_sent, :initiator, :is_a_reply_to_outbound, :message_id, :name, :unassigned_contact, :contact_id, :user_id, :batch_id
  belongs_to :contact
  belongs_to :user
  
  after_create :assign_contact
  after_update :create_touchpoint
  
  private
  
  def assign_contact
    user = self.user
    contact = user.contacts.find_by_fullname(self.name)
    if contact.nil?
      contact = user.contacts.create(:fullname => self.name)
      puts "created a new contact from linked in message"
    end
    self.update_attributes(:contact_id => contact.id)
  end

  def create_touchpoint
    Touchpoint.create(
      name: 'linked_in_message',
      direction: self.initiator,
      touchpoint_date: self.date_sent,
      subject: self,
      user: self.user,
      contact: self.contact
      )
  end

  def self.newest(initiator, user)
    ary = user.linked_in_messages.where(:initiator => initiator).sort_by &:date_sent
    return ary.last.date_sent
  end
   
end

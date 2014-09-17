class LinkedInMessage < ActiveRecord::Base
  attr_accessible :date_sent, :initiator, :is_a_reply_to_outbound, :message_id, :name, :unassigned_contact, :contact_id, :user_id, :batch_id
  belongs_to :contact
  belongs_to :user
  
  after_create :assign_contact
  after_update :create_touchpoint
  
  private
  
  def assign_contact
    contact = Contact.find_by_handle_linked_in(self.name)
    if contact
      self.update_attributes(:contact_id => contact.id)
      create_touchpoint
    else
      puts "contact doesn't exist yet"
    end
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

class EmailGmail < ActiveRecord::Base
  attr_accessible :contact_email, :contact_name, :date_sent, :direction, :message_id, :subject, :unassigned_contact, :contact_id, :user_id, :batch_id
  belongs_to :contact
  belongs_to :user
  
  after_create :assign_contact
  after_update :create_touchpoint
  private
  
  def assign_contact
    contact = Contact.find_by_handle_email(self.contact_email)
    if contact
      self.update_attributes(:contact_id => contact.id)
      #create_touchpoint
    else
      puts "contact doesn't exist yet"
    end
  end

  def create_touchpoint
    Touchpoint.create(
      name: 'email',
      direction: self.direction,
      touchpoint_date: self.date_sent,
      subject: self,
      user: self.user,
      contact: self.contact
      )
  end

  def self.newest(direction, user)
    ary = user.email_gmails.where(:direction => direction).sort_by &:date_sent
    return ary.last.date_sent
  end
  
end

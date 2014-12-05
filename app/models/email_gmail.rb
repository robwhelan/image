class EmailGmail < ActiveRecord::Base
  attr_accessible :contact_email, :contact_name, :date_sent, :direction, :message_id, :subject, :unassigned_contact, :contact_id, :user_id, :batch_id
  belongs_to :contact
  belongs_to :user
  
  
  after_create :assign_contact
  after_update :create_touchpoint
  #private
  
  def assign_contact
    user = self.user
    begin
      contact = Email.find_by_email(self.contact_email).contact
    rescue
      contact = user.contacts.find_by_fullname(self.contact_name)
      unless contact
        contact = user.contacts.create(:fullname => self.contact_name)
        puts "created new contact from email"
      end
      contact.emails.create(:email => self.contact_email) #add the email to the Contact's list of emails
    end
    
    self.update_attributes(:contact_id => contact.id)
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
  
end

class Touchpoint < ActiveRecord::Base
  belongs_to :subject, :polymorphic => true
  belongs_to :user
  belongs_to :contact
  attr_accessible :direction, :name, :touchpoint_date, :user, :contact, :subject_id, :subject_type, :subject
  
  after_create :show_contact_as_actionable
  
  def show_contact_as_actionable
    contact.update_attributes(:show_as_actionable => true)
  end
  
end

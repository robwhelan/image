class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact
  attr_accessible :body, :user_id, :contact_id
  after_create :create_touchpoint

  private
  
  def create_touchpoint
    Touchpoint.create(
      name: 'comment',
      direction: 'about',
      touchpoint_date: self.created_at,
      subject: self,
      user: self.user,
      contact: self.contact
      )
  end

end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :handle_phone, :handle_linked_in
  # attr_accessible :title, :body
  
  has_many :touchpoints, dependent: :destroy
  has_many :call_verizons, dependent: :destroy
  has_many :email_gmails, dependent: :destroy
  has_many :linked_in_invitations, dependent: :destroy
  has_many :linked_in_messages, dependent: :destroy
  has_many :text_verizons, dependent: :destroy
  has_many :contacts, dependent: :destroy

  def recent_touchpoints(limit)
    touchpoints.order('created_at DESC').limit(limit)
  end
  
  def contacts_shown_as_actionable
    self.contacts.where(:show_as_actionable => true)
  end

end

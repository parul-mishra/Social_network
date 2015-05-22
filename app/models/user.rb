class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
# Setup accessible (or protected) attributes for your model
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url =>"/system/users/avatars/000/000/002/thumb/missing.jpg"
  validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }
# has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/front.jpg"
# validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
validates :username,
  :presence => true,
  :uniqueness => {:case_sensitive => false}


  validates :email,
  :presence => true,
  :uniqueness => {:case_sensitive => false}


  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :omniauthable


  after_update :send_password_change_email, if: :needs_password_change_email?

  has_one :profile
  accepts_nested_attributes_for :profile  

  has_many :friendships
  has_many :passive_friendships, :class_name => "Friendship", :foreign_key => "friend_id"

  has_many :active_friends, -> { where(friendships: { approved: true}) }, :through => :friendships, :source => :friend
  has_many :passive_friends, -> { where(friendships: { approved: true}) }, :through => :passive_friendships, :source => :user
  has_many :pending_friends, -> { where(friendships: { approved: false}) }, :through => :friendships, :source => :friend
  has_many :requested_friendships, -> { where(friendships: { approved: false}) }, :through => :passive_friendships, :source => :user
 
  has_many :active_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  "Relationship",foreign_key: "followed_id", dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :converzations, :foreign_key => :sender_id
  has_many :identities , :dependent => :destroy

  has_many :messages , :dependent => :destroy

  has_many :posts
  has_many :comments

  acts_as_messageable
 
  def mailboxer_name
    self.name
  end

  def friend_approved(friend_id)
    all_request = friendships.where(:friend_id => friend_id, :approved => true) + passive_friendships.where(:user_id => friend_id, :approved => true)
    all_request.first
  end

 def friend_not_approved(friend_id)
    all_request = friendships.where(:friend_id => friend_id, :approved => false)
    all_request.first
  end
 
  def mailboxer_email(object)
    self.email
  end


  def self.search(query)
    where("email like ?", "%#{query}%") 
  end


  def self.create_from_omniauth(params, provider)
    if provider == 'twitter' 
      if params['info']['nickname'].present?
        email = params['info']['nickname'].gsub(" ", "")
        email = email+'@testdemo.com'
      else
        email = ''
      end
      username = params['info']['nickname']
    else
      email = params['info']['email']
      username = params['info']['name']
    end

    attributes = {
      username: username,
      email: email,
      password: Devise.friendly_token
    }

    u = create(attributes)

  end  

   def feed
    r = Relationship.arel_table
    t = Post.arel_table
    sub_query = t[:user_id].in(r.where(r[:follower_id].eq(id)).project(r[:followed_id]))
    Post.where(sub_query.or(t[:user_id].eq(id)))
  end
  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end


 def friends
      active_friends | passive_friends
 end




    protected
      def confirmation_required?
        false
      end

  private

  def needs_password_change_email?
    encrypted_password_changed? && persisted?
  end

  def send_password_change_email
    UserMailer.password_changed(id).deliver
  end

  

end
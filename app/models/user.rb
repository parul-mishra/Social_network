class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
# Setup accessible (or protected) attributes for your model
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url =>"/system/users/avatars/missing.jpg"
  validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }
# has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/front.jpg"
# validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :omniauthable


  has_many :converzations, :foreign_key => :sender_id
  has_many :identities , :dependent => :destroy


  acts_as_messageable
 
  def mailboxer_name
    self.name
  end
 
  def mailboxer_email(object)
    self.email
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

    protected
      def confirmation_required?
        false
      end

    
end
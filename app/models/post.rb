class Post < ActiveRecord::Base
	belongs_to :user
    has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url =>"/system/users/avatars/000/000/002/thumb/missing.jpg"
    validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }
    has_many :comments
    include PublicActivity::Model
    tracked owner: ->(controller, model) { controller && controller.current_user }
end

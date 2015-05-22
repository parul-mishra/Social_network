class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
	scope :friend_approved, lambda { |friend_id|
	  where(:friend_id => friend_id, :approved => true).first
	}  


   scope :friend_not_approved, lambda { |friend_id|
	  where(:friend_id => friend_id, :approved => false).first
	}  

end

class Massage < ActiveRecord::Base
  belongs_to :converzation
  belongs_to :user

  validates_presence_of :body, :converzation_id, :user_id

end

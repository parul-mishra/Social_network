class UsersController < ApplicationController

def index
end

  def show
    @user = User.find(params[:id])
     @activities = PublicActivity::Activity.where(owner_id: @user.id, owner_type: "User")
  end
  
 def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  end


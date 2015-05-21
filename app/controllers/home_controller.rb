class HomeController < ApplicationController
  def index
        if signed_in?
       @users = User.where.not("id = ?",current_user.id).order("created_at DESC")
       @converzation = Converzation.involving(current_user).order("created_at DESC")
    end
  end
  
  def dashboard
      if signed_in?
       @users = User.where.not("id = ?",current_user.id).order("created_at DESC")
       @converzation = Converzation.involving(current_user).order("created_at DESC")
     end
  end
  
end

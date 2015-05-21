class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead. 
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :mailbox ,  :conversation

include PublicActivity::StoreController
  # ...
   hide_action :current_user
  private
 
  def mailbox
    @mailbox ||= current_user.mailbox
  end
 
  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :current_password, :is_female, :date_of_birth, :avatar) }
  end
end

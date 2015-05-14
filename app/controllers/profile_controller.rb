class ProfileController < ApplicationController
  def index
  	@title="social Application"
  end
  def show
        @user = User.find(params[:id])
    end
  end

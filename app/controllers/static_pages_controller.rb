class StaticPagesController < ApplicationController
	 def home
    if signed_in?
      @post = Post.new 
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end

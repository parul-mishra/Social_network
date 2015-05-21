class CommentsController < ApplicationController
    before_filter :authenticate_user!, only: [:create, :destroy]
    def create
        @post = Post.find(params[:comment][:post_id])
        @comment = @post.comments.create!(comment_params)
        @comment.user = current_user
        @comment.save
        redirect_to @post
    end

    private

       def comment_params
            params.require(:comment).permit(:post_id, :comment, :content)
        end
end


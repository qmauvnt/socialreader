class CommentsController < ApplicationController
  def create
    @review=Review.find(params[:review_id])
    @review.comments.create(comment_params)
    redirect_to @review
  end

  def destroy
    @review=Review.find(params[:review_id])
    @review.comments.find(params[:id]).delete
    redirect_to @review
    flash[:success] = "Your comment has been deleted!"
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id, :content)
  end

end

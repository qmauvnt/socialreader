class CommentsController < ApplicationController
  def create
    @review=Review.find(params[:review_id])
    @review.comments.create(comment_params)
    redirect_to @review
  end

  def destroy
    Review.find(params[:review_id]).comments.find(params[:id]).delete
    redirect_to :back
    flash[:success] = "Your comment has been deleted!"
  end

  private
  def comment_params
    params.require(:comme'nt).permit(:user_id, :content)
  end

end

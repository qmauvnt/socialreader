class Admin::ReviewsController < Admin::AdminController
  def index
  end

  def show
    @review=Review.find(params[:id])
    @comment= @review.comments.build
  end

  def destroy
  end
end

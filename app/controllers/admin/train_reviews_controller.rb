class Admin::TrainReviewsController < Admin::AdminController
  def index
    @train_reviews=TrainReview.all
  end

  def new

  end

  def create
    begin
      @train_review=TrainReview.create train_review_params
      @train_text=TrainText.find(train_review_params[:_id])
      @train_text.delete
      redirect_to admin_train_reviews_path
    rescue  => e
      flash[:danger] = e
      @train_review=TrainReview.find(train_review_params[:_id])
      redirect_to edit_admin_train_review_path(@train_review)
    end
  end

  def show
    @train_review=TrainReview.find(params[:id])
    @review=Review.find(params[:id])
  end

  def edit
    @review=Review.find(params[:id])
    @train_review=TrainReview.find(params[:id])
  end

  def update
    @train_review=TrainReview.find params[:id]
    @train_review.update_attributes train_review_params
    redirect_to [:admin,@train_review]
    flash[:sucess]= "Train data has been updated"
  end

  def destroy
    TrainReview.find(params[:id]).delete
    redirect_to admin_train_reviews_path
    flash[:sucess]= "Train review has been deleted"
  end

  private
  def train_review_params
    params.require(:train_review).permit(:_id,:review,:category)
  end
end

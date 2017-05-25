class Admin::TestReviewsController < Admin::AdminController
 def index
    @test_reviews=TestReview.all
  end

  def new

  end

  def create
    begin
      @test_review=TestReview.create test_review_params
      @train_text=TrainText.find(test_review_params[:_id])
      unless @train_text.nil?
        @train_text.delete
        redirect_to admin_test_reviews_path
      else
        redirect_to new_admin_train_review_path
      end
    rescue  => e
      flash[:danger] = e
      @test_review=TestReview.find(test_review_params[:_id])
      redirect_to edit_admin_test_review_path(@test_review)
    end
  end

  def show
    @test_review=TestReview.find(params[:id])
    @review=Review.find(params[:id])
  end

  def edit
    @review=Review.find(params[:id])
    @test_review=TestReview.find(params[:id])
  end

  def update
    @test_review=TestReview.find params[:id]
    @test_review.update_attributes test_review_params
    redirect_to [:admin,@test_review]
    flash[:sucess]= "Test data has been updated"
  end

  def destroy
    TestReview.find(params[:id]).destroy
    redirect_to admin_test_reviews_path
    flash[:sucess]= "Train review has been deleted"
  end

  private
  def test_review_params
    params.require(:test_review).permit(:_id,:review,:category)
  end
end

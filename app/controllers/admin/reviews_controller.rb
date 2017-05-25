class Admin::ReviewsController < Admin::AdminController
  def index
    @reviews=Review.with_params(params).page params[:page]
  end

  def edit
    @review=Review.find params[:id]
  end

  def update
    @review=Review.find params[:id]
    params[:review][:review]=Nokogiri::HTML(params[:review][:content]).text
    params[:review][:tag]=params[:review][:tag].split(",").to_a
    @review.update_attributes review_params
    redirect_to [:admin,@review]
    flash[:success] = "Review has been updated"
  end

  def show
    @review=Review.find(params[:id])
    @comment= @review.comments.build
  end

  def destroy
    @review=Review.find params[:id]
    @review.destroy
    flash[:success] = "Review has been deleted"
    redirect_to admin_reviews_path
  end

  def new
    @review=current_user.reviews.build
  end

  def create
    params[:review][:tag]=params[:review][:tag].split(",").to_a
    params[:review][:review]=Nokogiri::HTML(params[:review][:content]).text
    current_user.reviews.create! review_params
    redirect_to admin_reviews_path
  end

  private
  def review_params
    params.require(:review).permit(:title, :host, :category, :published_date, :popular, :content, :review, :tag => [])
  end
end

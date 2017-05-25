class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
   @reviews=Review.with_params(params).page params[:page]
  end

  def show
      @review=Review.find(params[:id])
      @comment=@review.comments.build
      @train_text=TrainText.new
    if params[:clip]
      current_user.clipped_reviews << params[:clip] unless current_user.clipped_reviews.include? params[:clip]
      current_user.save
    elsif params[:unclip]
      current_user.clipped_reviews.delete(params[:unclip])
      current_user.save
    end
  end

  def new
    @review=current_user.reviews.build
  end

  def create
    params[:review][:tag]=params[:review][:tag].split(",").to_a
    params[:review][:review]=Nokogiri::HTML(params[:review][:content]).text
    current_user.reviews.create! review_params
    redirect_to reviews_path
  end

  private
  def review_params
    params.require(:review).permit(:title, :host, :category, :published_date, :popular, :content, :review, :tag => [])
  end
end

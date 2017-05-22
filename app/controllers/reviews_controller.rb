class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:search]
      @all=Review.search params[:search]
    elsif params[:tag]
      @all=Review.by_tag params[:tag]
    elsif params[:forum]
      @all=Review.by_host params[:forum]
    elsif params[:category]
      @all=Review.by_category params[:category]
    else
       @all=Review.all
    end
    @reviews=@all.ordered_by_popular.page(params[:page])
  end

  def show
    @review=Review.find(params[:id])
    @comment=@review.comments.build
    @train_text=TrainText.new
  end

  def new
    @review=current_user.reviews.build
  end

  def create
    params[:review][:tag]=params[:review][:tag].split(",").to_a
    params[:review][:review]=Nokogiri::HTML(params[:review][:content]).text
    byebug
    current_user.reviews.create! review_params
    redirect_to reviews_path
  end

  private
  def review_params
    params.require(:review).permit(:title, :host, :category, :published_date, :popular, :content, :review, :tag => [])
  end
end

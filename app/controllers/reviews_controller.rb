class ReviewsController < ApplicationController
  CATEGORIES=["general","camera","design","misc","perform"]

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
end

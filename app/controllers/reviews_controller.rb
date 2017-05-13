class ReviewsController < ApplicationController
  def index
    @all=Review.all
    @reviews=Kaminari.paginate_array(@all).page(params[:page]).per(20)
  end
  def show
    @review=Review.find(params[:id])
  end
end

class StaticPagesController < ApplicationController
  def home
    all=Review.all
    @best_reviews=Kaminari.paginate_array(all).page(params[:page]).per(5)
  end
end

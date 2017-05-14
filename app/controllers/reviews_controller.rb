class ReviewsController < ApplicationController
  CATEGORIES=["general","camera","design","misc","perform"]

  def index
    if params[:search]
      @all=Review.search params[:search]
    elsif params[:tag]
      @all=Review.by_tag params[:tag]
    elsif params[:forum]
      @all=Review.by_host params[:forum]
    elsif params[:type]
      @all=Review.by_type params[:type]
    else
       @all=Review.all
    end
    @reviews=Kaminari.paginate_array(@all).page(params[:page]).per(20)
    @general=Kaminari.paginate_array(@all.general).page(params[:page]).per(20)
    @camera=Kaminari.paginate_array(@all.camera).page(params[:page]).per(20)
    @design=Kaminari.paginate_array(@all.design).page(params[:page]).per(20)
    @misc=Kaminari.paginate_array(@all.misc).page(params[:page]).per(20)
    @perform=Kaminari.paginate_array(@all.perform).page(params[:page]).per(20)
  end

  def show
    @review=Review.find(params[:id])
  end
end

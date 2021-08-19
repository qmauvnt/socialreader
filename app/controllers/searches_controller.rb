class SearchesController < ApplicationController
  before_action :sign_in_required
  def new
    @search=Search.new
  end

  def create
    @search=Search.create! search_params
    redirect_to @search
  end

  def show
    @search=Search.find params[:id]
    @reviews=@search.reviews.page params[:page]
  end

  private
  def search_params
    params.require(:search).permit(:category,:keyword,:just_title,:host,:published_after,:ordered_by_date)
  end
  def sign_in_required
    unless user_signed_in?
      flash[:danger] = "You have to log in "
      redirect_to new_user_session_path
    end
  end
end

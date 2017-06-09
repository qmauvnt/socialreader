class TrainTextsController < ApplicationController
  def create
    review=Review.find(params[:train_text][:review_id])
    review.create_train_text train_text_params
    # train_text=TrainText.new_text train_text_params
    redirect_to review
    flash[:success]= "Thanks for your contribution"
  end

  private
  def train_text_params
    params[:train_text][:category]=[params[:train_text][:category]]
    params.require(:train_text).permit(:review_id,:category => [])
  end
end

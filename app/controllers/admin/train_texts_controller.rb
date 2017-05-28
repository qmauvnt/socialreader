class Admin::TrainTextsController < Admin::AdminController
  def index
    @train_texts=TrainText.all
  end

  def show
    @train_text=TrainText.find params[:id]
    @review=Review.find params[:id]
  end

  def destroy
    @train_text=TrainText.find params[:id]
    @train_text.destroy
    flash[:sucess]="The train text has been deleted"
    redirect_to admin_train_texts_path
  end
end

class Admin::TrainsController < Admin::AdminController
  def index
    @trains=Train.all
    @lastest_train=Train.first
  end

  def create
    Train.create
    redirect_to admin_trains_path
  end

  def update
    @train=Train.find(params[:id])
    @train.update_attributes(classified: true)
    redirect_to admin_trains_path
  end
end

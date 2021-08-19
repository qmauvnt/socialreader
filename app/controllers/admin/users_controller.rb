class Admin::UsersController < Admin::AdminController
  def index
    @users=User.all
  end

  def edit
    @user=User.find params[:id]
  end

  def update
    @user=User.find params[:id]
    @user.update_attributes user_params
    redirect_to admin_users_path
    flash[:success]="User has been updated"
  end

  def destroy
    @user=User.find params[:id]
    @user.destroy
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit(:name,:admin)
  end
end

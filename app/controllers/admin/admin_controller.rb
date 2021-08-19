class Admin::AdminController < ApplicationController
before_action :verify_admin

private
  def verify_admin
    flash[:danger]= "You're not admin and not allowed to do this action"
    redirect_to root_path unless current_user&&current_user.admin?
  end
end

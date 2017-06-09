class Admin::StaticPagesController < Admin::AdminController
  def home
    @best_reviews=Review.all.unscoped.ordered_by_date.page(params[:page])
  end
end

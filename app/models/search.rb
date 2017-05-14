class Search
  include Mongoid::Document

  field :keyword, type: String
  field :just_title, type: Boolean
  field :host, type: String
  field :published_after, type: Date
  field :ordered_by_date, type: Boolean

  def reviews
    @reviews ||= find_reviews
  end

  private
  def find_reviews
    reviews=Review.all
    reviews=reviews.full_text_search(self.keyword) if self.keyword.present?
    reviews=reviews.ordered_by_date if self.ordered_by_date?
    reviews=reviews.by_host(host) if self.host.present?
    reviews=reviews.after_date(self.published_after) if self.published_after.present?
    reviews
  end
end

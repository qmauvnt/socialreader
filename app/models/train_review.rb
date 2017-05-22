class TrainReview
  include Mongoid::Document
  include Mongoid::Timestamps
  after_create :update_trainned_review

  field :_id, type: String
  field :category, type: String

  default_scope -> { order_by(:created_at => 'desc') }
  scope :by_category, ->(category) { where(:category => category)}

  def update_trainned_review
    review=Review.find(self.id)
    review.trained=true
    review.save
  end
end

class TrainReview
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String
  field :review, type: String
  field :category, type: String

  default_scope -> { order_by(:created_at => 'desc') }
  scope :by_category, ->(category) { where(:category => category)}


end

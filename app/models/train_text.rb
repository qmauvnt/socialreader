class TrainText
  include Mongoid::Document

  field :_id, type: String
  field :category, type: Array
  validates :review_id, uniqueness: true

  belongs_to :review
  default_scope -> { order_by(:created_at => 'desc') }
  scope :unchecked, ->{where(checked: false)}

  class << self
    def new_text params
      review=Review.find(params[:review_id])
      train_text=review.train_text
      unless train_text
      review.create_train_text(category:[params[:category]])
      else
        categories=train_text.category << params[:category]
        train_text.category= categories
        byebug
      end
    end
  end

end

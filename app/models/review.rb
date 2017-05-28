class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  before_destroy :delete_reviews

  CATEGORIES=["general","camera","design","misc","perform"]
  HOSTS=["tinhte.vn","mainguyen.vn"]

  belongs_to :user
  embeds_many :comments
  validates :title, presence: true
  validates :category, presence: true
  validates :host, presence: true
  validates :review, presence: true
  validates :content, presence: true

  field :id, type: String
  field :title, type: String
  field :host, type: String, default: "socialreader"
  field :category, type: String, default: "unclassified"
  field :url,type: String
  field :published_date, type: DateTime
  field :tag, type: Array
  field :popular, type: Integer
  field :review, type: String
  field :content, type: String
  field :trainned, type: Boolean, default: false

  default_scope -> { order_by(:popular => 'desc') }
  scope :untrained, ->{ where(:trainned => false)}
  scope :native, ->{ where(host: "socialreader")}
  scope :ordered_by_popular, -> { order_by(:popular => 'desc') }
  scope :by_category, ->(category) { where(:category => category)}
  scope :by_host, ->(host) {where(:host => host)}
  scope :crawled, ->{where(:url.exists => true)}
  scope :after_date, ->(date) { where(:published_date.gte => date)}
  scope :ordered_by_date, -> { order(published_date: :desc) }
  scope :by_tag, ->(tag) { where(:tag => tag)}

  scope :tinhte, ->{ where("host": "tinhte.vn") }

  index({ title: "text", tag: "text", review: "text" })

  def delete_reviews
    train_review=TrainReview.find(self.id)
    test_review=TestReview.find(self.id)
    if train_review
      train_review.destroy
    elsif test_review
      test_review.destroy
    else
    end
  end



  class << self
    def by_host_category host,category
      where(host: host, category: category)
    end

    def with_params params
      reviews=Review.all
      reviews=reviews.search params[:search] if params[:search]
      reviews=reviews.by_tag params[:tag] if params[:tag]
      reviews=reviews.by_host params[:forum] if params[:forum]
      reviews=reviews.by_category params[:category] if params[:category]
      reviews
    end

    def search search
      if search
        Review.text_search("\"#{search}\"")
      else
        Review.all
      end
    end
  end

end

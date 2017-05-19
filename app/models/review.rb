class Review

  include Mongoid::Document
  include Mongoid::Timestamps

  CATEGORIES=["general","camera","design","misc","perform"]
  HOSTS=["tinhte.vn","mainguyen.vn"]

  belongs_to :user
  embeds_many :comments

  field :id, type: String
  field :title, type: String
  field :host, type: String
  field :category, type: String, default: "unclassified"
  field :url,type: String
  field :published_date, type: DateTime
  field :tag, type: Array
  field :popular, type: Integer
  field :review, type: String
  field :content, type: String

  scope :ordered_by_popular, -> { order_by(:popular => 'desc') }
  scope :by_category, ->(category) { where(:category => category)}
  scope :by_host, ->(host) {where(:host => host)}
  scope :after_date, ->(date) { where(:published_date.gte => date)}
  scope :ordered_by_date, -> { order(published_date: :desc) }
  scope :by_tag, ->(tag) { where(:tag => tag)}

  scope :tinhte, ->{ where("host": "tinhte.vn") }
 
  index({ title: "text", tag: "text", review: "text" }) 
 
  class << self
  def by_host_category host,category
    where(host: host, category: category)
  end

  def search search
    if search
      Review.text_search(search)
    else
      Review.all
    end
  end
  end

end

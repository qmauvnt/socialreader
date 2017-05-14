class Review
  store_in collection: "reviews", database: "socialreader_development"

  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include Mongoid::Search

  TYPES=["general","camera","design","misc","perform"]
  HOSTS=["tinhte.vn","mainguyen.vn"]


  field :id, type: String
  field :title, type: String
  field :host, type: String
  field :type, type: String
  field :url,type: String
  field :published_date, type: DateTime
  field :tag, type: Array
  field :popular, type: Integer
  field :review, type: String
  field :content, type: String

  default_scope -> { order_by(:popular => 'desc') }
  scope :by_type, ->(type) { where(:type => type)}
  scope :by_host, ->(host) {where(:host => host)}
  scope :general, ->{ where("type"=>"general")}
  scope :camera, ->{ where("type"=>"camera")}
  scope :design, ->{ where("type"=>"design")}
  scope :misc, ->{ where("type"=>"misc")}
  scope :perform, ->{ where("type"=>"perform")}
  scope :after_date, ->(date) { where(:published_date.gte => date)}
  scope :ordered_by_date, -> { order(published_date: :desc) }
  scope :by_tag, ->(tag) { where(:tag => tag)}

  scope :tinhte, ->{ where("host": "tinhte.vn") }
  search_in :title, :review, :tag

  class << self
  def by_host_type host,type
    where(host: host, type: type)
  end

  def search search
    if search
      Review.full_text_search(search)
    else
      Review.all
    end
  end
  end

end

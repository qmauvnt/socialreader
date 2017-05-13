class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "reviews", database: "socialreader_development"

  attr_accessor :host

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

  scope :general, ->{ where("type": "general") }
  scope :camera, ->{ where("type": "camera") }
  scope :design, ->{ where("type": "design") }
  scope :misc, ->{ where("type": "misc") }
  scope :perform, ->{ where("type": "perform") }

  scope :tinhte, ->{ where("host": "tinhte.vn") }
end

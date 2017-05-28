class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :content, presence: true

  embedded_in :review, :inverse_of => :comments

  field :content, type: String
  field :user_id, type: BSON::ObjectId
end

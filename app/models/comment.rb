class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  embedded_in :review, :inverse_of => :comments

  field :content, type: String
  field :user_id, type: BSON::ObjectId

  def creator
    User.find(self.user_id.to_i)
  end
end

class TrainText
  include Mongoid::Document

  field :_id, type: String
  field :review, type: String
  field :category, type: Array
  field :checked, type: Boolean, default: false

  default_scope -> { order_by(:created_at => 'desc') }
  scope :unchecked, ->{where(checked: false)}

  class << self
    def new_text params
      begin
       self.create(_id:params[:_id], review:params[:review], category:[params[:category]])
      rescue
        t=TrainText.find(params[:_id])
        t.category << params[:category]
        t.save
      end
    end
  end

end

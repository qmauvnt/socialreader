class User
  include Mongoid::Document
  include Mongoid::Paperclip
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_mongoid_attached_file :avatar, :style => {:default_url => "images/missing.png"}
  field :name, type: String
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :admin, type: Boolean, default: false
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  field :remember_created_at, type: Time
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

end

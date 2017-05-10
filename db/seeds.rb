user = User.create! email: "admin@gmail.com", password: "123456789", password_confirmation: "123456789", admin: true
user = User.create! email: "user@gmail.com", password: "123456789", password_confirmation: "123456789", admin: false

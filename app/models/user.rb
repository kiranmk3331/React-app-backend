class User < ApplicationRecord
  has_secure_password
  before_validation { self.email = email.downcase }

  validates :user_name, presence: true
  validates :email, presence: :true, uniqueness: true, on: :create
  validates :password, presence: :true, on: :create
end

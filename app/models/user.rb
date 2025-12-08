class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items
  has_many :orders
  has_many :activity_logs

  def admin?
    role == "admin"
  end
end

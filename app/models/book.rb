class Book < ApplicationRecord
  has_many :cart_items
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end

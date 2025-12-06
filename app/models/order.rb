class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :name, :email, :address, :phone, presence: true, on: :create
  validates :total_price, presence: true

  def calculate_total
    order_items.sum { |item| item.unit_price * item.quantity }
  end

  def total_with_recalc
    calculate_total
  end
end

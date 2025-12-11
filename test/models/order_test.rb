require "test_helper"

class OrderTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", password: "password", role: "user")
    @order = @user.orders.build(
      name: "Іван Іванов",
      email: "test@example.com",
      address: "Київ",
      phone: "123456789",
      total_price: 200.0,
      shipping_method: "np",
      shipping_cost: 50.0
    )
    @order.save!
    @order.order_items.create!(book: Book.create!(title: "Book1", author: "A", price: 100), quantity: 2, unit_price: 100)
  end

  test "order should be valid with correct data" do
    assert @order.valid?
  end

  test "order should calculate total price correctly" do
    assert_equal 200, @order.calculate_total
  end
end

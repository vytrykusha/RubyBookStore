require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    sign_in @user
  end

  test "should get index when signed in" do
    get orders_url
    assert_response :success
  end

  test "should redirect to cart if no items when creating order" do
    post orders_url, params: { name: "Test", email: "test@example.com", address: "Київ", phone: "123" }
    assert_redirected_to cart_items_url
  end
end

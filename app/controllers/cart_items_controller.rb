class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart_items = current_user.cart_items
  end

  def create
    cart_item = current_user.cart_items.find_or_initialize_by(book_id: params[:book_id])
    cart_item.quantity ||= 0
    cart_item.quantity += 1
    cart_item.save
    redirect_to cart_items_path
  end

  def update
    cart_item = current_user.cart_items.find(params[:id])
    if params[:quantity].to_i > 0
      cart_item.update(quantity: params[:quantity])
      redirect_to cart_items_path, notice: "Кількість оновлена"
    else
      cart_item.destroy
      redirect_to cart_items_path, notice: "Товар видалено з кошика"
    end
  end

  def destroy
    cart_item = current_user.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_items_path
  end
end

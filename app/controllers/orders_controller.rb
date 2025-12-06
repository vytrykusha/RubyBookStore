
class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(created_at: :desc).page(params[:page]).per(6)
  end

  def new
    @cart_items = current_user.cart_items.includes(:book)
    if @cart_items.empty?
      redirect_to cart_items_path, alert: "Кошик порожній."
    end
  end

  def create
    @cart_items = current_user.cart_items.includes(:book)
    if @cart_items.empty?
      redirect_to cart_items_path, alert: "Кошик порожній." and return
    end

    # Зберігаємо контактні дані в order
    order = current_user.orders.build(
      status: "new",
      total_price: 0,
      name: params[:name],
      email: params[:email],
      address: params[:address],
      phone: params[:phone]
    )

    # Розраховуємо суму перед створенням order_items
    total_amount = 0
    order_items_data = []

    @cart_items.each do |item|
      price = item.book.price
      discount = item.book.discount.to_f
      final_price = discount > 0 ? (price * (1 - discount/100)) : price
      subtotal = final_price * item.quantity

      total_amount += subtotal
      order_items_data << {
        book_id: item.book_id,
        quantity: item.quantity,
        unit_price: final_price
      }
    end

    # Встановлюємо рахункову суму
    order.total_price = total_amount

    # Створюємо order_items
    order_items_data.each do |data|
      order.order_items.build(data)
    end

    if order.save
      @cart_items.destroy_all
      redirect_to orders_path, notice: "Замовлення успішно оформлено!"
    else
      flash.now[:alert] = "Не вдалося оформити замовлення. Перевірте дані."
      render :new, status: :unprocessable_entity
    end
  end
end

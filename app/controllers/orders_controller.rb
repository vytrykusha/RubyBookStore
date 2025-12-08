class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [ :show ]

  def index
    @orders = current_user.orders.order(created_at: :desc).page(params[:page]).per(6)
  end

  def show
    # Генеруємо LiqPay рахунок. LiqPayService сам використовує sandbox або .env ключі
    @invoice = LiqPayService.create_invoice(@order)
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
    # determine shipping method and cost
    shipping_method = params[:shipping_method].to_s
    shipping_cost = case shipping_method
    when "np" then 50.0
    when "courier" then 100.0
    when "pickup" then 0.0
    else 50.0
    end

    order = current_user.orders.build(
      status: "new",
      total_price: 0,
      name: params[:name],
      email: params[:email],
      address: params[:address],
      phone: params[:phone],
      shipping_method: shipping_method,
      shipping_cost: shipping_cost
    )

    # Розраховуємо суму перед створенням order_items
    total_amount = 0
    order_items_data = []

    @cart_items.each do |item|
      price = item.book.price
      discount = item.book.discount.to_f
      final_price_usd = discount > 0 ? (price * (1 - discount/100)) : price

      # Convert unit price to UAH for order storage and display
      final_price_uah = CurrencyConverter.usd_to_uah(final_price_usd)
      subtotal = final_price_uah * item.quantity

      total_amount += subtotal
      order_items_data << {
        book_id: item.book_id,
        quantity: item.quantity,
        unit_price: final_price_uah
      }
    end

    # Встановлюємо рахункову суму (додаємо вартість доставки)
    order.total_price = total_amount + (order.shipping_cost || 0.0)

    # Створюємо order_items
    order_items_data.each do |data|
      order.order_items.build(data)
    end

    if order.save
      @cart_items.destroy_all
      redirect_to order_path(order), notice: "Замовлення успішно оформлено! Тепер оплатіть його."
    else
      flash.now[:alert] = "Не вдалося оформити замовлення. Перевірте дані."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end
end

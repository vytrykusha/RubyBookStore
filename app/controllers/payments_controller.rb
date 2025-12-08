class PaymentsController < ApplicationController
  skip_forgery_protection only: [ :liqpay_notify ]
  before_action :authenticate_user!, only: [ :mark_payment ]
  before_action :set_order, only: [ :mark_payment, :status ]

  def liqpay_notify
    data_encoded = params[:data]
    signature = params[:signature]

    if LiqPayService.verify_notification(data_encoded, signature)
      result = LiqPayService.process_payment(data_encoded)
      render json: result
    else
      render json: { success: false, message: "Invalid signature" }, status: :forbidden
    end
  end

  def status
    if @order&.user == current_user || current_user&.admin?
      render json: {
        order_id: @order.id,
        payment_status: @order.payment_status || "pending",
        status: @order.status
      }
    else
      render json: { error: "Unauthorized" }, status: :forbidden
    end
  end

  def mark_payment
    if @order.user == current_user || current_user&.admin?
      @order.update(payment_status: "completed", status: "confirmed")
      redirect_to order_path(@order), notice: "✅ Тестова оплата успішна!"
    else
      redirect_to orders_path, alert: "Доступ заборонено."
    end
  rescue => e
    Rails.logger.error("Payment error: #{e.message}")
    redirect_to orders_path, alert: "Помилка при обробці платежу."
  end

  def pay_cash
    if @order.user == current_user || current_user&.admin?
      @order.update(payment_status: "cash_on_delivery", status: "confirmed")
      redirect_to order_path(@order), notice: "✅ Замовлення позначено як " + "Оплата готівкою при отриманні".to_s
    else
      redirect_to orders_path, alert: "Доступ заборонено."
    end
  rescue => e
    Rails.logger.error("Cash payment error: #{e.message}")
    redirect_to orders_path, alert: "Підтвердження оплати готівкою в процесі..."
  end

  private

  def set_order
    @order = Order.find_by(id: params[:order_id])
    redirect_to orders_path, alert: "Замовлення не знайдено." unless @order
  end
end

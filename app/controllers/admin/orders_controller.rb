class Admin::OrdersController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @orders = Order.all.order(created_at: :desc)
  end


  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update(status: params[:status])
    redirect_to admin_orders_path
  end

  private

  def require_admin
    redirect_to root_path, alert: "Доступ заборонено" unless current_user&.admin?
  end
end

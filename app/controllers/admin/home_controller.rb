module Admin
  class HomeController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      # Simple admin landing page. Keep it lightweight — main navigation is in the layout.
      # Provide some quick counts so the page isn't empty.
      @total_users = User.count
      @total_orders = Order.count
      @total_books = Book.count
    end

    private

    def require_admin
      redirect_to root_path, alert: "Доступ заборонено" unless current_user&.admin?
    end
  end
end

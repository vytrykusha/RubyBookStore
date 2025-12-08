module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      @total_users = User.count
      @total_orders = Order.count
      @total_revenue = Order.sum(:total_price) || 0
      @today_orders = Order.where("DATE(created_at) = ?", Date.today).count

      # Активність за останні 7 днів
      @daily_activity = (7.days.ago.to_date..Date.today).map do |date|
        count = ActivityLog.where("DATE(created_at) = ?", date).count
        { date: date.strftime("%d.%m"), count: count }
      end

      # Популярні книги
      @popular_books = Book.left_joins(:comments)
        .group("books.id")
        .select("books.id, books.title, books.author, COUNT(comments.id) as comments_count")
        .order("comments_count DESC")
        .limit(5)

      # Активність за типами
      @activity_by_type = ActivityLog
        .group(:action)
        .count
        .transform_keys { |k| ActivityLog.actions.key(k) || k }

      # Кількість замовлень по дням
      @orders_by_day = (7.days.ago.to_date..Date.today).map do |date|
        count = Order.where("DATE(created_at) = ?", date).count
        { date: date.strftime("%d.%m"), count: count }
      end

      # Revenue по дням
      @revenue_by_day = (7.days.ago.to_date..Date.today).map do |date|
        revenue = Order.where("DATE(created_at) = ?", date).sum(:total_price) || 0
        { date: date.strftime("%d.%m"), revenue: revenue.to_f }
      end

      # If there's no real data (fresh DB), provide lightweight sample data so charts render
      if @daily_activity.all? { |d| d[:count].to_i == 0 } && @orders_by_day.all? { |d| d[:count].to_i == 0 }
        sample_dates = (7.days.ago.to_date..Date.today).map { |d| d.strftime("%d.%m") }
        sample_counts = [ 2, 3, 5, 4, 6, 2, 3 ]
        @daily_activity = sample_dates.zip(sample_counts).map { |date, c| { date: date, count: c } }
        @orders_by_day = sample_dates.zip(sample_counts.map { |c| (c/2.0).to_i }).map { |date, c| { date: date, count: c } }
        @revenue_by_day = sample_dates.zip(sample_counts.map { |c| c * 120.0 }).map { |date, r| { date: date, revenue: r } }
        @activity_by_type = { "view" => 20, "add_to_cart" => 8, "purchase" => 5 }
      end
    end

    private

    def require_admin
      redirect_to root_path, alert: "Доступ заборонено" unless current_user&.admin?
    end
  end
end

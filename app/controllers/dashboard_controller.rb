class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def analytics
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
  end

  def api_analytics
    case params[:type]
    when "daily_activity"
      data = (7.days.ago.to_date..Date.today).map do |date|
        count = ActivityLog.where("DATE(created_at) = ?", date).count
        { date: date.strftime("%d.%m"), count: count }
      end
      render json: { data: data }
    when "activity_types"
      data = ActivityLog.group(:action).count
      render json: { data: data }
    when "orders_trend"
      data = (7.days.ago.to_date..Date.today).map do |date|
        count = Order.where("DATE(created_at) = ?", date).count
        { date: date.strftime("%d.%m"), count: count }
      end
      render json: { data: data }
    when "revenue_trend"
      data = (7.days.ago.to_date..Date.today).map do |date|
        revenue = Order.where("DATE(created_at) = ?", date).sum(:total_price) || 0
        { date: date.strftime("%d.%m"), revenue: revenue.to_f }
      end
      render json: { data: data }
    else
      render json: { error: "Unknown type" }, status: :bad_request
    end
  end

  private
  def require_admin
    redirect_to root_path, alert: "Доступ заборонено" unless current_user&.admin?
  end
end

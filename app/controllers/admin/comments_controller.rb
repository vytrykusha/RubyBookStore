class Admin::CommentsController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @comments = Comment.order(created_at: :desc)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_path, notice: "Коментар видалено."
  end

  private

  def require_admin
    redirect_to root_path, alert: "Доступ заборонено" unless current_user&.admin?
  end
end

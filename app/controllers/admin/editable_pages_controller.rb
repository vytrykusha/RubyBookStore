class Admin::EditablePagesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @pages = EditablePage.all
  end

  def edit
    @page = EditablePage.find(params[:id])
  end

  def update
    @page = EditablePage.find(params[:id])
    if @page.update(editable_page_params)
      redirect_to admin_editable_pages_path, notice: "Сторінку оновлено"
    else
      render :edit
    end
  end

  private

  def editable_page_params
    params.require(:editable_page).permit(:content)
  end

  def require_admin
    redirect_to root_path, alert: "Доступ заборонено" unless current_user.admin?
  end
end

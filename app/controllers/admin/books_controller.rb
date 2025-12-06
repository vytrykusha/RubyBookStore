class Admin::BooksController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :require_admin

  def show
    @book = Book.find(params[:id])
  end
  layout "admin"
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to admin_books_path, notice: "Книга створена"
    else
      render :new
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to admin_books_path, notice: "Книга оновлена"
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to admin_books_path, notice: "Книга видалена"
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :price, :description, :category, :discount, :cover)
  end

  def require_admin
    redirect_to root_path, alert: "Доступ заборонено" unless current_user.admin?
  end
end

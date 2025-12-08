class BooksController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :require_admin, except: [ :index, :show ]
  before_action :set_book, only: [ :show, :edit, :update, :destroy ]

  # GET /books or /books.json
  def index
    books_scope = Book.all

    # Пошук за назвою або автором
    if params[:q].present?
      q = params[:q].downcase
      books_scope = books_scope.where("LOWER(title) LIKE ? OR LOWER(author) LIKE ?", "%#{q}%", "%#{q}%")
    end

    # Фільтр за ціною
    if params[:min_price].present?
      books_scope = books_scope.where("price >= ?", params[:min_price])
    end
    if params[:max_price].present?
      books_scope = books_scope.where("price <= ?", params[:max_price])
    end

    # Фільтр по категорії
    if params[:category].present?
      books_scope = books_scope.where(category: params[:category])
    end

    # Фільтр по знижці
    if params[:discounted].present? && params[:discounted] == "1"
      books_scope = books_scope.where("discount > 0")
    end

    # Сортування
    case params[:sort]
    when "title_asc"
      books_scope = books_scope.order(title: :asc)
    when "title_desc"
      books_scope = books_scope.order(title: :desc)
    when "price_asc"
      books_scope = books_scope.order(price: :asc)
    when "price_desc"
      books_scope = books_scope.order(price: :desc)
    else
      books_scope = books_scope.order(created_at: :desc)
    end

    @books = books_scope.page(params[:page]).per(12)
  end

  # GET /books/1 or /books/1.json
  def show
    # Логуємо перегляд книги
    if user_signed_in?
      ActivityLog.log_action(current_user, :viewed_book, "Book", @book.id,
        { title: @book.title, category: @book.category }, request)
    end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, notice: "Book was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
  def require_admin
    redirect_to root_path, alert: "Доступ заборонено" unless current_user&.admin?
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author, :price, :stock, :description, :cover, :category, :discount)
    end
end

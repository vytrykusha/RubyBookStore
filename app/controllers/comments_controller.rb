class CommentsController < ApplicationController
  before_action :set_book

  def create
    @comment = @book.comments.build(comment_params)
    if @comment.save
      redirect_to @book, notice: "Коментар додано."
    else
      redirect_to @book, alert: "Помилка при додаванні коментаря."
    end
  end

  def destroy
    @comment = @book.comments.find(params[:id])
    @comment.destroy
    redirect_to @book, notice: "Коментар видалено."
  end

  private
    def set_book
      @book = Book.find(params[:book_id])
    end

    def comment_params
      params.require(:comment).permit(:content, :author)
    end
end

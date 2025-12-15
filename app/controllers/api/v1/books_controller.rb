module Api
  module V1
    class BooksController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        books = Book.all
        render json: books.as_json(only: [ :id, :title, :author, :price ])
      end

      def create
        book = Book.new(book_params)

        if book.save
          render json: book, status: :created
        else
          render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def book_params
        params.require(:book).permit(:title, :author, :price)
      end
    end
  end
end

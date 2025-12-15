require "swagger_helper"

RSpec.describe "Books API", type: :request do
  path "/api/v1/books" do
    get "Get list of books" do
      tags "Books"
      produces "application/json"

      response "200", "books list" do
        run_test!
      end
    end

    post "Create a book" do
      tags "Books"
      consumes "application/json"

      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          book: {
            type: :object,
            properties: {
              title: { type: :string },
              author: { type: :string },
              price: { type: :number }
            },
            required: %w[title author price]
          }
        }
      }

      response "201", "book created" do
        let(:book) do
          { book: { title: "Test", author: "Author", price: 100 } }
        end
        run_test!
      end
    end
  end
end

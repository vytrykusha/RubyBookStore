json.extract! book, :id, :title, :author, :price, :stock, :description, :cover, :created_at, :updated_at
json.url book_url(book, format: :json)

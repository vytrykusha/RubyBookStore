require "test_helper"

class BookTest < ActiveSupport::TestCase
  def setup
    @book = Book.new(
      title: "Test Book",
      author: "Test Author",
      price: 100,
      category: "Класика",
      description: "Опис книги",
      discount: 10
    )
  end

  test "should be valid with correct attributes" do
    assert @book.valid?
  end

  test "should not save book without title" do
    @book.title = nil
    assert_not @book.valid?
  end

  test "should not allow negative price" do
    @book.price = -50
    assert_not @book.valid?, "Book saved with negative price"
  end

  test "should apply discount correctly" do
    discounted_price = @book.price * (1 - @book.discount / 100.0)
    assert_equal 90, discounted_price
  end
end

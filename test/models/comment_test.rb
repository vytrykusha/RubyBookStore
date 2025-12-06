require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @book = Book.create!(title: "Коментована книга", author: "Автор", price: 50)
    @comment = @book.comments.build(author: "Гість", content: "Дуже цікаво")
  end

  test "should be valid with content" do
    assert @comment.valid?
  end

  test "should not be valid without content" do
    @comment.content = nil
    assert_not @comment.valid?
  end
end

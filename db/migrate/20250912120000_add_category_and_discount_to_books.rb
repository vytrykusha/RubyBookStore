class AddCategoryAndDiscountToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :category, :string
    add_column :books, :discount, :decimal, precision: 5, scale: 2, default: 0
  end
end

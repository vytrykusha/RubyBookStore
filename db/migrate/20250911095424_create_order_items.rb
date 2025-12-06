class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :book_id
      t.integer :quantity
      t.decimal :unit_price

      t.timestamps
    end
  end
end

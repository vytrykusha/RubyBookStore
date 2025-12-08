class AddShippingToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :shipping_method, :string
    add_column :orders, :shipping_cost, :decimal, precision: 10, scale: 2, default: 0.0
  end
end

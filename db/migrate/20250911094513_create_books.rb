class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.decimal :price
      t.integer :stock
      t.text :description
      t.string :cover

      t.timestamps
    end
  end
end

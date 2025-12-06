class CreateEditablePages < ActiveRecord::Migration[7.2]
  def change
    create_table :editable_pages do |t|
      t.string :slug, null: false
      t.text :content, null: false
      t.timestamps
    end
    add_index :editable_pages, :slug, unique: true
  end
end

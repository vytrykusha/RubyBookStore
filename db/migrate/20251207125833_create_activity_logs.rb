class CreateActivityLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :activity_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.string :resource_type
      t.integer :resource_id
      t.text :details
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end

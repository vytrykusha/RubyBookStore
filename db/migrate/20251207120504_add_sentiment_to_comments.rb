class AddSentimentToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :sentiment, :string
  end
end

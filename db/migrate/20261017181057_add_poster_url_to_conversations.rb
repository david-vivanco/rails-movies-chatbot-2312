class AddPosterUrlToConversations < ActiveRecord::Migration[8.1]
  def change
    add_column :conversations, :poster_, :string
  end
end

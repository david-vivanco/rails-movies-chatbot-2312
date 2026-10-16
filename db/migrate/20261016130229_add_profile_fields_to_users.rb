class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string
    add_column :users, :avatar_url, :string
    add_column :users, :cinema_profile, :string
    add_column :users, :favorite_genres, :string, array: true, default: []
    add_column :users, :disliked_genres, :string, array: true, default: []
    add_column :users, :user_prompt, :text
  end
end

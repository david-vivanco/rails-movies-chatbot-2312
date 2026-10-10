class AddPopulariteToCriteria < ActiveRecord::Migration[8.1]
  def change
    add_column :criteria, :popularite, :string, array: true, default: []
  end
end

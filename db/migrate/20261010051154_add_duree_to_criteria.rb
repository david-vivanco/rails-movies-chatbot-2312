class AddDureeToCriteria < ActiveRecord::Migration[8.1]
  def change
    add_column :criteria, :duree, :string, array: true, default: []
  end
end

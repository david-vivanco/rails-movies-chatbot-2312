class AddAmbianceToCriteria < ActiveRecord::Migration[8.1]
  def change
    add_column :criteria, :ambiance, :string, array: true, default: []
  end
end

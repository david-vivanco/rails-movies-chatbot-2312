class AddAudianceToCriteria < ActiveRecord::Migration[8.1]
  def change
    add_column :criteria, :audiance, :string, array: true, default: []
  end
end

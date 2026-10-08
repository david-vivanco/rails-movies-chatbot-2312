class CreateCriteria < ActiveRecord::Migration[8.1]
  def change
    create_table :criteria do |t|
      t.string :prompt
      t.string :keywords
      t.string :genres, array: true, default: []

      t.timestamps
    end
  end
end

class CreateFleets < ActiveRecord::Migration[7.1]
  def change
    create_table :fleets do |t|
      t.references :aircraft, null: false, foreign_key: true
      t.string :livery, null: false
      t.timestamps
    end
  end
end

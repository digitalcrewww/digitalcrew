class CreateMultipliers < ActiveRecord::Migration[7.1]
  def change
    create_table :multipliers do |t|
      t.string :name, null: false
      t.float :value, null: false, default: 1.0
      t.timestamps
    end
  end
end

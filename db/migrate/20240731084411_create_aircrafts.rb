class CreateAircrafts < ActiveRecord::Migration[7.1]
  def change
    create_table :aircrafts do |t|
      t.string :name, null: false
      t.string :icao_code, null: false
      t.timestamps
    end

    add_index :aircrafts, :name, unique: true
    add_index :aircrafts, :icao_code, unique: true
  end
end

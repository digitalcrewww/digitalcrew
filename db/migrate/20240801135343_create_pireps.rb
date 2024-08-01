class CreatePireps < ActiveRecord::Migration[7.1]
  def change
    create_table :pireps do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :flight_number, null: false
      t.date :flight_date, null: false
      t.string :departure_icao, null: false
      t.string :arrival_icao, null: false
      t.integer :flight_time_minutes, null: false
      t.decimal :fuel_used, null: false
      t.integer :cargo, null: false
      t.references :fleet, null: false, foreign_key: true, index: true
      t.references :multiplier, foreign_key: true, index: true

      t.timestamps
    end

    add_index :pireps, :flight_number
    add_index :pireps, :departure_icao
    add_index :pireps, :arrival_icao
  end
end

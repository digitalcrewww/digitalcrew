class CreateRoutes < ActiveRecord::Migration[7.1]
  def change
    create_table :routes do |t|
      t.string :flight_number, null: false
      t.string :departure_icao, null: false
      t.string :arrival_icao, null: false
      t.integer :duration, null: false

      t.timestamps
    end

    add_index :routes, :flight_number, unique: true
    add_index :routes, %i[departure_icao arrival_icao]
  end
end

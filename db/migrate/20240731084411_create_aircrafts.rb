class CreateAircrafts < ActiveRecord::Migration[7.1]
  def change
    create_table :aircrafts do |t|
      t.string :name, null: false
      t.string :icao_code, null: false

      t.timestamps
    end
  end
end

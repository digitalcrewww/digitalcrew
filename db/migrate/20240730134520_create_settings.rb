class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.string :airline_name, null: false
      t.string :callsign, null: false
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :settings, :airline_name, unique: true
    add_index :settings, :callsign, unique: true
  end
end

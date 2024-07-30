class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_id, null: false
      t.string :user_agent
      t.datetime :expires_at, null: false
      t.timestamps
    end

    add_index :sessions, :session_id, unique: true
  end
end

class MovePersistanceToPostgres < ActiveRecord::Migration[5.2]
  def change
    create_table :snakes do |t|
      t.string :name, null: false
      t.jsonb :head_position
      t.jsonb :segment_positions, default: []
      t.string :color, null: false
      t.string :intent
      t.string :last_intent, null: false
      t.string :ip_address, null: false
      t.string :auth_token, null: false
      t.timestamps
    end

    create_table :leaderboard_entries do |t|
      t.string :name, null: false
      t.integer :length, null: false
      t.timestamps
    end
  end
end

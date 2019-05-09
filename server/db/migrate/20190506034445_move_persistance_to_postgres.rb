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
      t.integer :length, null: false, default: 0
      t.datetime :died_at
      t.timestamps
    end
  end
end

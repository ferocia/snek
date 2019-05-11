class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.jsonb :position, null: false
      t.string :item_type, null: false
    end

    add_column :snakes, :items, :jsonb, default: [], null: false
  end
end

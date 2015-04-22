class CreateConverzations < ActiveRecord::Migration
  def change
    create_table :converzations do |t|
      t.integer :sender_id
      t.integer :recipient_id

      t.timestamps null: false
    end
     add_index :converzations, :sender_id
    add_index :converzations, :recipient_id
  end
end

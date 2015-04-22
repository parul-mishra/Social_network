class CreateMassages < ActiveRecord::Migration
  def change
    create_table :massages do |t|
      t.text :body
      t.references :converzation, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :massages, :converzations
    add_foreign_key :massages, :users
  end
end

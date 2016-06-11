class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.string :author
      t.string :haiku1
      t.string :haiku2
      t.string :haiku3
      t.string :haiku4
      t.string :haiku5
      t.integer :good, default: 0
      t.string :img
      t.timestamps null: false
    end
  end
end

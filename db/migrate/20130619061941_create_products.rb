class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :category_id
      t.string :unit
      t.integer :qty, :default => 0

      t.timestamps
    end
  end
end

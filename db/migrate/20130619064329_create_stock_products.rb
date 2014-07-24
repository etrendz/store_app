class CreateStockProducts < ActiveRecord::Migration
  def change
    create_table :stock_products do |t|
      t.integer :product_id
      t.float :price

      t.timestamps
    end
  end
end

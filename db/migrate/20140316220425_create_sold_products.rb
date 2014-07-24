class CreateSoldProducts < ActiveRecord::Migration
  def change
    create_table :sold_products do |t|
      t.integer :stock_product_id
      t.integer :product_id
      t.integer :purchase_product_id
      t.integer :sale_product_id
      t.float :price
      t.float :cprice

      t.timestamps
    end
  end
end

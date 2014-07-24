class CreateSaleProducts < ActiveRecord::Migration
  def change
    create_table :sale_products do |t|
      t.integer :product_id
      t.integer :sale_id
      t.integer :qty
      t.float :cprice
      t.float :price

      t.timestamps
    end
  end
end

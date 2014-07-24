class CreatePurchaseProducts < ActiveRecord::Migration
  def change
    create_table :purchase_products do |t|
      t.integer :product_id
      t.integer :purchase_id
      t.integer :qty
      t.float :price

      t.timestamps
    end
  end
end

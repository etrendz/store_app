class CreateSaleReturns < ActiveRecord::Migration
  def change
    create_table :sale_returns do |t|
      t.references :sale, index: true
      t.references :product, index: true
      t.integer :qty
      t.float :cprice
      t.float :price

      t.timestamps
    end
  end
end

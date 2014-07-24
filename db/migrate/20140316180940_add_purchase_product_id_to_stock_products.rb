class AddPurchaseProductIdToStockProducts < ActiveRecord::Migration
  def change
    add_column :stock_products, :purchase_product_id, :integer
    add_column :stock_products, :sale_product_id, :integer
  end
end

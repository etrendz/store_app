class AddCpriceToStockProducts < ActiveRecord::Migration
  def change
    add_column :stock_products, :cprice, :float
  end
end

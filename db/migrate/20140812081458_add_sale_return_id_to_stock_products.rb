class AddSaleReturnIdToStockProducts < ActiveRecord::Migration
  def change
    add_reference :stock_products, :sale_return, index: true
  end
end

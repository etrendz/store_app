class AddOrderToSales < ActiveRecord::Migration
  def change
    add_column :sales, :order, :string
  end
end

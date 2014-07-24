class AddCpriceToPurchaseProducts < ActiveRecord::Migration
  def change
    add_column :purchase_products, :cprice, :float
  end
end

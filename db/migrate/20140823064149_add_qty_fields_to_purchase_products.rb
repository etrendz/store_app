class AddQtyFieldsToPurchaseProducts < ActiveRecord::Migration
  def change
    add_column :purchase_products, :invoice_qty, :integer
    add_column :purchase_products, :received_qty, :integer
  end
end

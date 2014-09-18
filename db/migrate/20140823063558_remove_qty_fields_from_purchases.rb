class RemoveQtyFieldsFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :invoice_qty, :integer
    remove_column :purchases, :received_qty, :integer
    remove_column :purchases, :accepted_qty, :integer
  end
end

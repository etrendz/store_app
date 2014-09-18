class AddFieldsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :suppliers_invoice, :string
    add_column :purchases, :invoice_date, :date
    add_column :purchases, :amount, :string
    add_column :purchases, :invoice_qty, :integer
    add_column :purchases, :received_qty, :integer
    add_column :purchases, :accepted_qty, :integer
  end
end

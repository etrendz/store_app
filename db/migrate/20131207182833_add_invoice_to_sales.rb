class AddInvoiceToSales < ActiveRecord::Migration
  def change
    add_column :sales, :invoice, :string
  end
end

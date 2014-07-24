class AddVatToSales < ActiveRecord::Migration
  def change
    add_column :sales, :vat, :integer, :default => 0
  end
end

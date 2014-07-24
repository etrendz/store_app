class AddDiscountToSales < ActiveRecord::Migration
  def change
    add_column :sales, :discount, :integer, :default => 0
  end
end

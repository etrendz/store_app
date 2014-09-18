class AddDetailsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :receipt_type, :string
  end
end

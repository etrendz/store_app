class AddDcToSales < ActiveRecord::Migration
  def change
    add_column :sales, :dc, :string
  end
end

class AddTinToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :tin, :string
  end
end

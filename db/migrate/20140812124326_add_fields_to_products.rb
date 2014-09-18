class AddFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :cprice, :string
    add_column :products, :price, :string
    add_column :products, :size, :string
    add_column :products, :description, :string
  end
end

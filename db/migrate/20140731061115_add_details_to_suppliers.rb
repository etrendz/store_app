class AddDetailsToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :code, :string
    add_column :suppliers, :address1, :string
    add_column :suppliers, :address2, :string
    add_column :suppliers, :city, :string
    add_column :suppliers, :pincode, :string
    add_column :suppliers, :state, :string
    add_column :suppliers, :phone, :string
    add_column :suppliers, :email, :string
    add_column :suppliers, :contact_person, :string
    add_column :suppliers, :tin, :string
    add_column :suppliers, :cst, :string
    add_column :suppliers, :pan, :string
  end
end

class AddTransportToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :transport, :string
    add_column :purchases, :lr_no, :string
    add_column :purchases, :discount, :float
    add_column :purchases, :freight, :integer
    add_column :purchases, :dc, :integer
    add_column :purchases, :vat, :integer
    add_column :purchases, :cst, :integer
    add_column :purchases, :duty, :integer
    add_column :purchases, :edu_cess, :integer
    add_column :purchases, :surcharge, :integer
    add_column :purchases, :round_off, :float
    add_column :purchases, :debit_note, :integer
  end
end

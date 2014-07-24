class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.references :customer
      t.references :sale

      t.timestamps
    end
    add_index :payments, :customer_id
    add_index :payments, :sale_id
  end
end

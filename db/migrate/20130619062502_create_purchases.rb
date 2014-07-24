class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :invoice
      t.integer :supplier_id
      t.date :purchase_date
      t.boolean :paid

      t.timestamps
    end
  end
end

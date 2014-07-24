class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :customer_id
      t.date :sale_date
      t.boolean :paid
      t.string :remark

      t.timestamps
    end
  end
end

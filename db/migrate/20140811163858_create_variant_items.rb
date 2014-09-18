class CreateVariantItems < ActiveRecord::Migration
  def change
    create_table :variant_items do |t|
      t.string :name
      t.references :variant, index: true

      t.timestamps
    end
  end
end

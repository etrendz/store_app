class Purchase < ActiveRecord::Base

  has_many :purchase_products, dependent: :destroy
  belongs_to :supplier
	
  accepts_nested_attributes_for :purchase_products, allow_destroy: true 
	
  validates :invoice, :purchase_products, presence: true
  validates :invoice, uniqueness: true
  
 def new_purchase_product_attributes=attributes
	attributes.each do |record|
	  purchase_products.build(record)
	end
 end
 
 def total_amount
	sum = 0
	purchase_products.each do |pp|
		sum += pp.cprice * pp.qty
	end
  sum
 end
 
end

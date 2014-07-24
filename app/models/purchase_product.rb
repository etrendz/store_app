class PurchaseProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :purchase
	has_many :stock_products, dependent: :destroy
  after_create { |pp|	
									pp.product.sum_qty(pp.qty)
									pp.qty.times{ pp.product.stock_products.create(:purchase_product_id => pp.id, :price => pp.price, :cprice => pp.cprice)	}
								}
  before_destroy{ |pp| 
#									pp.qty.times{ pp.product.stock_products.last.destroy	}
									pp.product.decrease_qty(pp.qty)
								}
								
before_update { |pp|	
		temp = PurchaseProduct.find(pp.id)
		puts "Before - #{temp.qty} : After - #{pp.qty}"
		change_qty = temp.qty - pp.qty 
		if change_qty > 0
			change_qty.times{ pp.product.stock_products.last.destroy	}
			pp.product.decrease_qty(change_qty)
		else
			(change_qty * -1).times{ pp.product.stock_products.create(:purchase_product_id => pp.id, :price => pp.price, :cprice => pp.cprice)	}
			pp.product.sum_qty(change_qty * -1)
		end
		
		if temp.cprice != pp.cprice 
			pp.stock_products.each do |sp|
				sp.update_attributes(:cprice => pp.cprice)	
			end
		end
		
		if temp.price != pp.price 
			pp.stock_products.each do |sp|
				sp.update_attributes(:price => pp.price)	
			end
		end
	}

	
 def full_price
	price * qty
 end
end

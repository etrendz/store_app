class SaleProduct < ActiveRecord::Base
  belongs_to :customer
  belongs_to :product
  belongs_to :sale
	has_many :stock_products
	has_many :sold_products
  
  after_create { |sp| 
		cp_total = 0
		p_total = 0
		sp.product.decrease_qty(sp.qty)
		sp.qty.times{ 
			p "======SP================="
			p sp.product.stock_products.first
			p sp.product.stock_products.length
			first_sp = sp.product.stock_products.first
			cp_total += first_sp.cprice   #SOME MISTAKE IS HERE
			SoldProduct.create(:product_id => first_sp.product_id, :purchase_product_id => first_sp.purchase_product_id, :price => first_sp.price, :cprice => first_sp.cprice, :sale_product_id => sp.id, :stock_product_id => first_sp.id)
			sp.product.stock_products.first.destroy
		} 
		sp.update_column(:cprice, cp_total)		
	}
	before_destroy 	{ |sp|	
		sp.qty.times { 
				sold_product = sp.sold_products.last	
				sp.product.stock_products.create(:id => sold_product.stock_product_id, :purchase_product_id => sold_product.purchase_product_id, :price => sold_product.price, :cprice => sold_product.cprice)	
		}
		sp.product.sum_qty(sp.qty)
	}
	
			before_update { |sp|	
				temp = SaleProduct.find(sp.id)
				cprice = temp.cprice / temp.qty
				price = temp.price / temp.qty
				puts "Before - #{temp.qty} : After - #{sp.qty}"
				change_qty = temp.qty - sp.qty 
				if change_qty > 0
					change_qty.times{ 
						sp.cprice = sp.cprice - cprice
						sp.price = sp.price - price
						sold_product = sp.sold_products.last	 
						sp.product.stock_products.create(:id => sold_product.stock_product_id, :purchase_product_id => sold_product.purchase_product_id, :price => sold_product.price, :cprice => sold_product.cprice)	
						sp.sold_products.last.destroy
					}
					sp.product.sum_qty(change_qty)
				else
					(change_qty * -1).times{ 
						sp.cprice = sp.cprice + cprice
						sp.price = sp.price + price
						first_sp = sp.product.stock_products.first
						SoldProduct.create(:product_id => first_sp.product_id, :purchase_product_id => first_sp.purchase_product_id, :price => first_sp.price, :cprice => first_sp.cprice, :sale_product_id => sp.id, :stock_product_id => first_sp.id)
						sp.product.stock_products.first.destroy
					}
					sp.product.decrease_qty(change_qty * -1)
				end
				
			}

end

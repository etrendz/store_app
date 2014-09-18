class SaleReturn < ActiveRecord::Base
  belongs_to :sale
  belongs_to :product
	
  after_create { |sr|	
									sr.product.sum_qty(sr.qty)
									sr.qty.times{ sr.product.stock_products.create(:sale_return_id => sr.id, :price => sr.price / sr.qty, :cprice => sr.cprice / sr.qty)	}
								}

  before_destroy{ |sr| 
#									sr.qty.times{ sr.product.stock_products.last.destroy	}
									sr.product.decrease_qty(sr.qty)
								}

end

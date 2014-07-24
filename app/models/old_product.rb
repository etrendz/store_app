class Product < ActiveRecord::Base
  belongs_to :category
  has_many :stock_products
  has_many :purchase_products
  has_many :sale_products
  has_many :sales, :through => :sale_products
  
  validates :name, :code, presence: true
  validates :code, uniqueness: true
  attr_accessible :category_id, :name, :qty, :unit, :code, :_delete
	
	
  def self.import(file)
	CSV.foreach(file.path, headers: true) do |row|
	 c = Product.new
     c.category_id = Category.find_or_create_by_name(row[0]).id
	 c.name = row[1]
     c.unit = row[2]
	 c.qty = row[3].to_i
	 c.qty.times {
			c.stock_products.build(:price => row[4].to_f)
		}
     c.save
	end
   end
  
	
	def sum_qty(fqty)
		update_attribute('qty', self.qty + fqty)
	end
	
	def decrease_qty(fqty)
		update_attribute('qty', self.qty - fqty)
	end
	
	def opening(till_date)
		on_date["qty"] = 0
		on_date["cprice"] = 0.0
		on_date["price"] = 0.0
		purchase_on_date = Purchase.where("purchase_date < ? ", till_date)
		purchase_product_on_date = purchase_on_date.purchase_products.where(:product_id => self.id)
		
		purchase_product_on_date.each { |am|
				on_date["qty"] = on_date["qty"] + am.qty
				on_date["price"] = on_date["price"] + am.price
		}
=begin
		purchase_on_date.each { |ar|
			ar.purchase_products.each { |am|
				if am.product_id == self.id
					on_date["qty"] = on_date["qty"] + am.qty
					on_date["price"] = on_date["price"] + am.price
				end
			}
		}
=end
		
		sale_on_date = Sale.where("sale_date < ? ", till_date)
		sale_product_on_date = sale_on_date.sale_products.where(:product_id => self.id)
		
			sale_product_on_date.each { |sp|
					on_date["qty"] = on_date["qty"] - sp.qty
					on_date["price"] = on_date["price"] - sp.price * sp.qty
			}
=begin
		sale_on_date.each { |ar|
			ar.sale_products.each { |sp|
				if sp.product_id == self.id
					on_date["qty"] = on_date["qty"] - sp.qty
	#				on_date["cprice"] = on_date["cprice"] - sp.cprice * sp.qty
					on_date["price"] = on_date["price"] - sp.price * sp.qty
				end
			}
		}
=end
		
		
		
		on_date
	end

	def purchase_on_date_range(from, to)
		on_date = Hash.new
		on_date["qty"] = 0
		on_date["cprice"] = 0.0
		on_date["price"] = 0.0
		purchase_on_date = Purchase.where(:purchase_date => from..to)
		purchase_on_date.each { |ar|
			ar.purchase_products.each { |am|
				if am.product_id == self.id
					on_date["qty"] = on_date["qty"] + am.qty
					on_date["cprice"] = on_date["cprice"] + am.cprice
					on_date["price"] = on_date["price"] + am.price
				end
			}
		}
		
		on_date

	end


	def sale_on_date_range(from, to)
		on_date = Hash.new
		on_date["qty"] = 0
		on_date["price"] = 0.0
		on_date["cprice"] = 0.0
		@sale_on_date = Sale.where(:sale_date  => from..to)
		@sale_on_date.each { |ar|
			ar.sale_products.each { |sp|
				if sp.product_id == self.id
					on_date["qty"] = on_date["qty"] + sp.qty
					on_date["cprice"] = on_date["cprice"] + sp.cprice
					on_date["price"] = on_date["price"] + sp.price * sp.qty
				end
			}
		}
		on_date
	end
	
	def get_report(from, to)
	
	end
end

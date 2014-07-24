class Product < ActiveRecord::Base
  belongs_to :category
  has_many :stock_products, dependent: :destroy
  has_many :purchase_products
  has_many :sale_products
  has_many :sales, :through => :sale_products
  
  validates :name, :code, presence: true
  validates :code, uniqueness: true
	
	
  def self.import(file)
			CSV.foreach(file.path, headers: false) do |row|
			# mycode = Product.last ? Product.last.code.next : '000001'
			 c = Product.new(:code => row[5])
			 c.category_id = Category.find_or_create_by_name(row[0]).id
			 c.name = row[1]
			 c.unit = "Nos"
			 c.qty = 0
#			 c.qty.times {
	#			 c.stock_products.build(:price => row[2].to_f)
		#	 }

			 c.save
			 if (row[2].to_i != 0)
				 invoice = Purchase.last ? Purchase.last.invoice.next : 1
				 d = Purchase.new(:invoice => invoice, :purchase_date => Date.today, :supplier_id => 1, :paid => 1)
				 d.purchase_products.build(:product_id => Product.find_by_name(row[1]).id, :qty => row[2].to_i, :cprice => row[3].to_f, :price => row[4].to_f)
				 d.save
			 end
			end
   end
  
	
	def sum_qty(fqty)
		update_attribute('qty', self.qty + fqty)
	end
	
	def decrease_qty(fqty)
		update_attribute('qty', self.qty - fqty)
	end
	
	def opening(till_date)
		on_date = Hash.new
		on_date["qty"] = 0
		on_date["price"] = 0.0
		
		self.purchase_products.each do |pp|
			if pp.purchase.purchase_date < till_date
				on_date["qty"] = on_date["qty"] + pp.qty
				on_date["price"] = on_date["price"] + (pp.cprice * pp.qty)
			end
		end
		
		self.sale_products.each do |sp|
			if sp.sale.sale_date < till_date
				on_date["qty"] = on_date["qty"] - sp.qty
				on_date["price"] = on_date["price"] - (sp.cprice)
			end
		end
		
		on_date
	end

	def purchase_on_date_range(from, to)
		on_date = Hash.new
		on_date["qty"] = 0
		on_date["price"] = 0.0
		
			self.purchase_products.each do |pp|
				p_date = pp.purchase.purchase_date
				if (p_date >= from) && (p_date <= to)
					on_date["qty"] = on_date["qty"] + pp.qty
					on_date["price"] = on_date["price"] + (pp.cprice * pp.qty)
				end
			end
		
		on_date

	end

	def sale_on_date_range(from, to)
		on_date = Hash.new
		on_date["qty"] = 0
		on_date["cprice"] = 0.0
		on_date["price"] = 0.0
		
			self.sale_products.each do |sp|
				s_date = sp.sale.sale_date
				if (s_date >= from) && (s_date <= to)
					on_date["qty"] = on_date["qty"] + sp.qty
					on_date["price"] = on_date["price"] + sp.price
					on_date["cprice"] = on_date["cprice"] + sp.cprice
				end
			end
		on_date
	end
	
end

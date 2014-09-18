class Product < ActiveRecord::Base
  belongs_to :category
  has_many :stock_products, dependent: :destroy
  has_many :purchase_products
  has_many :sale_products
  has_many :sale_returns
  has_many :sales, :through => :sale_products
  
  validates :name, :uniqueness => {:scope => [:category_id, :brand, :size, :style, :cprice, :price]}
  validates :name, :code, presence: true
	
	
  def self.import(file)
			CSV.foreach(file.path, headers: false) do |row|
			# mycode = Product.last ? Product.last.code.next : '000001'
			 c = Product.new(:code => row[0])
			 c.category_id = Category.find_or_create_by_name(row[6]).id
			 c.name = row[1]
			 c.brand = row[2]
			 c.size = row[3]
			 c.style = row[4]
			 c.cprice = row[9].to_f
			 c.price = row[8].to_f
			 c.unit = "Nos"
			 c.qty = 0
#			 c.qty.times {
	#			 c.stock_products.build(:price => row[2].to_f, :price => row[6].to_f, :cprice => row[7].to_f)
		#	 }

			 c.save
			 if (row[7].to_i != 0)
#				 invoice = Purchase.last ? Purchase.last.invoice.next : 1purchase = Purchase.where("receipt_type like ?", "OG%").last
					invoice = Purchase.last ? Purchase.last.invoice.next : "OD - 1"
    		 d = Purchase.new(:invoice => invoice, :purchase_date => Date.today, :receipt_type => 'ODP', :supplier_id => 1, :paid => 1)
				 d.supplier_id = Supplier.find_or_create_by_name(row[10]).id
				 d.purchase_products.build(:product_id =>c.id, :qty => row[7].to_i, :cprice => row[9].to_f, :price => row[8].to_f)
				 d.save
			 end

			end
   end
	 
	def self.to_csv
		CSV.generate do |csv|
#			csv << column_names
	#		all.each do |product|
	#			csv << product.attributes.values_at(*column_names)
	#		end
			csv << [column_names[1], column_names[4], column_names[8], column_names[9], column_names[10], column_names[12], column_names[13], column_names[11] ]
			all.each do |product|
				csv << product.attributes.values_at(column_names[1], column_names[4], column_names[8], column_names[9], column_names[10], column_names[12], column_names[13], column_names[11])
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
					on_date["price"] = on_date["price"] + (sp.price - (sp.price * sp.sale.discount / 100))
					on_date["cprice"] = on_date["cprice"] + sp.cprice
				end
			end
		on_date
	end
	
	def sale_return_on_date_range(from, to)
		on_date = Hash.new
		on_date["qty"] = 0
		on_date["cprice"] = 0.0
		on_date["price"] = 0.0
		
			self.sale_returns.each do |sr|
				s_date = sr.created_at.to_date
				if (s_date >= from) && (s_date <= to)
					on_date["qty"] = on_date["qty"] + sr.qty
					on_date["price"] = on_date["price"] + sr.price
				end
			end
		on_date
	end
	
end

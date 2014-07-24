class Sale < ActiveRecord::Base
  has_many :sale_products, dependent: :destroy
  belongs_to :customer
  has_many :products, through: :sale_products
 
  validates :sale_products, presence: true
	
 def new_sale_product_attributes=attributes
	attributes.each do |record|
	  sale_products.build(record)
	end
 end
 
 
	def customer_name
		customer.try(:name)
	end
	
	def customer_name=(name)
		self.customer = Customer.find_or_create_by_name(name) if name.present?
	end
	
	def sale_amount
		price = 0
		sale_products.each do |sp|
			price += sp.price
		end
		price
	end
end

class Supplier < ActiveRecord::Base
  has_many :purchases
  has_many :products
  has_many :purchase_products
	
  validates :name, presence: true
	def purchases_between(from, to)
		purchases.where(:purchase_date  => from..to)
	end
end

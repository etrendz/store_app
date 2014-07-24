class Supplier < ActiveRecord::Base
  has_many :products
  has_many :purchase_products
	
  validates :name, presence: true
end

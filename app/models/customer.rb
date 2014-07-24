class Customer < ActiveRecord::Base
  has_many :products
  has_many :sales
	
  validates :name, presence: true, uniqueness: true
	
end

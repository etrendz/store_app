class PaymentReceived < ActiveRecord::Base
  attr_accessible :customer_id, :payment
end

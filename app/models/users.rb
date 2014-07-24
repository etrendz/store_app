class Users < ActiveRecord::Base
  attr_accessible :auth_token, :name, :email, :password_digest, :password_reset_sent_at, :password_reset_token
end

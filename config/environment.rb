# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Store::Application.initialize!
Rails.logger.level = 3
I18n.enforce_available_locales = false
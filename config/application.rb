require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'
#require 'rupees'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Store
  class Application < Rails::Application
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

  #  config.active_record.whitelist_attributes = true


    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
  end
end
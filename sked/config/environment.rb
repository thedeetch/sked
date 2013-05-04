# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Garys::Application.initialize!

APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]
Rails.logger = Logger.new(STDOUT)

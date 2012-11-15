# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'test/unit'
require 'active_support/all'
require 'active_record'
require 'serialize-rails'
require 'active_record/errors'
# require 'mocha'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'rack/test'
require 'database_cleaner'

require_relative File.join('../..', 'app')

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() SimpleApp end
end

# For RSpec 2.x
RSpec.configure do |config|
  config.include RSpecMixin
  config.color = true
  config.tty = true
  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  ActiveRecord::Base.logger.level = 1
end
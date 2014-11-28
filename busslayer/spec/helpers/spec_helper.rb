require 'rack/test'
require 'database_cleaner'
require 'codeclimate-test-reporter'
require 'factory_girl'

# FactoryGirl setup
FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryGirl.find_definitions

CodeClimate::TestReporter.start

require_relative File.join('../..', 'app')

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() SimpleApp end
end

# For RSpec 2.x
RSpec.configure do |config|
  ActiveRecord::Base.logger.level = 1
  config.include FactoryGirl::Syntax::Methods
  config.include RSpecMixin
  config.color = true
  config.tty = true
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
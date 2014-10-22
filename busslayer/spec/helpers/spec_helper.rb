require 'rack/test'

#require File.expand_path '../../../app.rb', __FILE__
require_relative File.join('../..', 'app')

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() SimpleApp end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }
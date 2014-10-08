require 'sinatra/base'

#Dir.glob('./{models,routes}/*.rb').each { |file| require file }

require_relative "routes/test"

class SimpleApp < Sinatra::Base
 
  set :root, File.dirname(__FILE__)
 
  enable :sessions
 
  #helpers Sinatra::SampleApp::Helpers
 
  register Sinatra::SampleApp::Routing::Test
  #register Sinatra::SampleApp::Routing::Secrets
  run! if app_file == $0
end
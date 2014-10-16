require 'sinatra/base'
require "sinatra/activerecord"
require "./models/user"

require_relative "routes/test"

class SimpleApp < Sinatra::Base
 
  set :root, File.dirname(__FILE__)
  set :database_file, "./db/database.yml"

  enable :sessions
 
  register Sinatra::ActiveRecordExtension
  register Sinatra::SampleApp::Routing::Test

  run! if app_file == $0
end
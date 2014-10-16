require 'sinatra/base'
require "sinatra/activerecord"
require "./models/user"
require "i18n"
require "json"

I18n.config.enforce_available_locales = false

require_relative "routes/users"
require_relative "routes/misc"

class SimpleApp < Sinatra::Base
 
  set :root, File.dirname(__FILE__)
  set :database_file, "./db/database.yml"

  

  enable :sessions
 
  register Sinatra::ActiveRecordExtension
  register Sinatra::SampleApp::Routing::Users
  register Sinatra::SampleApp::Routing::Misc

  run! if app_file == $0
end
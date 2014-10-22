require 'sinatra/base'
require "sinatra/activerecord"
require "i18n"
require "json"

#Used for loading models into the application
Dir["./models/*.rb"].each { |file| require file }

I18n.config.enforce_available_locales = false

#Used for loading routes
Dir["./routes/*.rb"].each { |file| require file }

ENV['RACK_ENV'] ||= 'development'


class SimpleApp < Sinatra::Base
 
  set :root, File.dirname(__FILE__)
  set :database_file, "./db/database.yml"

  

  enable :sessions
 
  register Sinatra::ActiveRecordExtension
  register Sinatra::Routing::Users
  register Sinatra::Routing::Misc

  run! if app_file == $0
end
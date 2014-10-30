require 'sinatra/base'
require "sinatra/activerecord"
require "i18n"
require "json"
require 'drb'
require 'thread'

#Used for loading models into the application
Dir["./models/*.rb"].each { |file| require file }

I18n.config.enforce_available_locales = false

#Used for loading routes
Dir["./routes/*.rb"].each { |file| require file }

require "./rmiserv"
ENV['RACK_ENV'] ||= 'development'
RMI_URL = 'druby://0.0.0.0:9000'


class SimpleApp < Sinatra::Base
 
  set :root, File.dirname(__FILE__)
  set :database_file, "./db/database.yml"

  enable :sessions
 
  register Sinatra::ActiveRecordExtension
  register Sinatra::Routing::Users
  register Sinatra::Routing::Apartments
  register Sinatra::Routing::Misc

  thr = Thread.new { DRb.start_service(RMI_URL, RMIServer.new) }
  
  #DRb.thread.join
  puts "RMIServer running at #{RMI_URL}"

  run! if app_file == $0

  # replace localhost with 0.0.0.0 to allow conns from outside
  
end
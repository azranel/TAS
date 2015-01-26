#!/usr/bin/env ruby

require 'sinatra/base'
require 'sinatra/activerecord'
require 'i18n'
require 'json'
require 'drb'
require 'thread'
require 'protobuf'
require 'protobuf/cli'
require 'protobuf/message'
require 'protobuf/rpc/service'

# Used for loading models into the application
Dir['./models/*.rb'].each { |file| require file }

I18n.config.enforce_available_locales = false

# Used for loading routes
Dir['./routes/*.rb'].each { |file| require file }

# Loading protobufs
Dir['./lib/**/*.rb'].each { |file| require file }

# Loading services
Dir['./services/**/*.rb'].each { |file| require file }

# Represents sinatra app (which is business layer)
class SimpleApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :database_file, './db/database.yml'

  enable :sessions

  register Sinatra::ActiveRecordExtension
  register Sinatra::Routing::Users
  register Sinatra::Routing::Apartments
  register Sinatra::Routing::Bills
  register Sinatra::Routing::Misc
  register Sinatra::Routing::Messages

  # TODO: Running RPC Server to handle RPC Protobuf requests
  services = Dir['./services/**/*.rb']
  services.unshift('start')
  unless ENV['TESTING'] == true.to_s
    thr = Thread.new { run! }
    ::Protobuf::CLI.start(services)
    thr.join
  end
end


require 'sinatra/base'
require 'sinatra/activerecord'
require 'i18n'
require 'json'
require 'thread'
require 'msgpack'
require './rpc_server'
require 'msgpack/rpc'

# Used for loading models into the application
Dir['./models/helpers/*.rb', './models/*.rb'].each { |file| require file }

# Used for loading routes
Dir['./routes/*.rb'].each { |file| require file }
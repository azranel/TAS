#!/usr/bin/env ruby
require "./requirments"



# Represents sinatra app (which is business layer)
class SimpleApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :database_file, './db/database.yml'

  enable :sessions

  I18n.config.enforce_available_locales = false

  RPCIP = '127.0.0.1'
  RPCPORT = 18800

  register Sinatra::ActiveRecordExtension
  register Sinatra::Routing::Users
  register Sinatra::Routing::Apartments
  register Sinatra::Routing::Bills
  register Sinatra::Routing::Misc
  register Sinatra::Routing::Messages

  unless ENV['TESTING'] == true.to_s || ENV['DB'] == true.to_s
    Thread.new do
      puts "[RPC] Running MessagePack RPC Server on #{ RPCIP } : #{ RPCPORT }"
      svr = MessagePack::RPC::Server.new
      svr.listen(RPCIP, RPCPORT, StatisticsHandler.new)
      svr.run
    end
    run!
    thr.join
  end
end

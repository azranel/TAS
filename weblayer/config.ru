Dir.glob('./{models,routes}/*.rb').each { |file| require file }
require './simpleapp'
run SimpleApp
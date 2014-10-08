Dir.glob('./{models,routes}/*.rb').each { |file| require file }

run SimpleApp
require 'protobuf'
require "./lib/stat/apartment.pb"

req = Stat::ApartmentStatRequest.new(name: "lol")

Stat::ApartmentStatService.client.fetch(req) do |c|
  c.on_success do |response|
    puts "Tenants count: #{ response.tenants_count }"
    puts "Bills value: #{ response.bills_value }"
    response.apartments.each do |a|
      puts "Apartment #{ a.name }, #{ a.description }"
    end
  end

  c.on_failure do |error|
    puts "FAIL: " + error.message
  end
end
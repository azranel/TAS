require 'factory_girl'

FactoryGirl.define do
  factory :apartment do
    user
    name 'Super mieszkanie'
    address 'Chrobrego 3/2'
    city 'Poznań'
    description 'Bardzo fajne mieszkanie w dużym mieście jakim jest Poznań'
  end
end

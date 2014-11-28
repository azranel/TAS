require 'factory_girl'

FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user do
    firstname "Bartosz"
    lastname "Łęcki"
    email
    password "alamakota"
    phone "636524711"
  end
end

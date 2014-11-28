require 'factory_girl'

FactoryGirl.define do
  factory :bill do
    association :owner, factory: :user, strategy: :build
    apartment
    name 'Rachunek za gaz i prąd' 
    description 'Taki tam rachunek heheszki'
    value 154.69
  end
end

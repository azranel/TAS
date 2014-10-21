class Apartment < ActiveRecord::Base
  has_many :users, :through => :users_apartments
  has_many :users_apartments

  validates :name, presence: true

end
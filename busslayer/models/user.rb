class User < ActiveRecord::Base
  validates :name, presence: true
  validates :lastname, presence: true
  validates :password, presence: true
  validates :phone, presence: true
  validates :email, confirmation: true
end
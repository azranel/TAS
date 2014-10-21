# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string(255)
#  lastname        :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  phone           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :password_digest, presence: true
  validates :phone, presence: true
  validates :email, confirmation: true, uniqueness: true

  has_many :apartments, :through => :users_apartments
  has_many :users_apartments
  has_secure_password
end

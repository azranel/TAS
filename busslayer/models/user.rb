# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  lastname   :string(255)
#  email      :string(255)
#  password   :string(255)
#  phone      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :name, presence: true
  validates :lastname, presence: true
  validates :password, presence: true
  validates :phone, presence: true
  validates :email, confirmation: true
end

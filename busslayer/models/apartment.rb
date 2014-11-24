# == Schema Information
#
# Table name: apartments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  address     :string(255)
#  city        :string(255)
#  user_id     :integer
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Apartment < ActiveRecord::Base
  has_many :users, :through => :users_apartments
  has_many :users_apartments
  has_many :bills
  belongs_to :user

  validates :name, presence: true
  validates :city, presence: true

  def have_user?(user)
    self.user == user || self.users.include?(user)
  end
end

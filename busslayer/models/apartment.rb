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
  has_many :users_apartments
  has_many :users, :through => :users_apartments
  has_many :messages

  has_many :bills

  belongs_to :user

  validates :name, presence: true
  validates :city, presence: true

  def have_resident?(user)
    self.users.include?(user)
  end

  def have_owner?(user)
    self.user == user
  end

  def have_owner_or_resident?(user)
    self.have_resident?(user) || self.have_owner?(user)
  end
end

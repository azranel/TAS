# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  subject      :string(255)
#  content      :text
#  user_id      :integer
#  apartment_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :apartment

  validates :subject, presence: true
  validates :content, presence: true

  validates :apartment, presence: true
  validates :user, presence: true

  validate :user_belong_to_apartment

  def user_belong_to_apartment
    errors.add(:wrong_user, 'User must belong to apartment') unless apartment.users.include?(user) || apartment.user==user
  end


  def fetch_hash(status_value = 200, values = [])
    hash = {}
    hash[:status] = status_value
    values.each do |value|
      hash[value] = self[value]
    end
    hash
  end

end

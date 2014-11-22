# == Schema Information
#
# Table name: bills
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :string(255)
#  value        :float
#  apartment_id :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Bill < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: 'user_id'
  belongs_to :apartment

  validates :name, presence: true, uniqueness: true
  validates :value, presence: true, 
        format: { with: /^.*\.\d{0,2}$/, multiline: true, message: 'value can have only 2 decimal places'}
  validates :apartment, presence: true
  validates :owner, presence: true

  def divide(persons_number=apartment.users.count)
    divided = value / persons_number
    divided.round(2)
  end

  def fetch_hash(status_value=200, values=[])
    hash = Hash.new
    hash[:status] = status_value
    values.each do |value|
      hash[value] = self[value]
    end
    hash
  end
end

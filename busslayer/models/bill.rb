# == Schema Information
#
# Table name: bills
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :text
#  value        :float
#  apartment_id :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Bill < ActiveRecord::Base
  has_many :users_bills
  has_many :users, through: :users_bills

  belongs_to :user
  belongs_to :apartment
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'

  validates :name, presence: true
  validates :value, presence: true, format: {
    with: /^.*\.\d{0,2}$/,
    multiline: true,
    message: 'value can have only 2 decimal places'
  }
  validates :apartment, presence: true
  validates :owner, presence: true

  def divide(number_of_debtors = users.count)
    return value if number_of_debtors.zero?
    divided = value / number_of_debtors
    divided.round(2)
  end

  def to_json
    super(methods: :divide)
  end

  def fetch_hash(status_value = 200, values = [])
    hash = {}
    hash[:status] = status_value
    values.each do |value|
      hash[value] = self[value]
    end
    hash
  end

  def self.all_bills_value
    sum = 0
    Bill.select("sum(value) as bills_value").each do |x|
      sum += x.bills_value
    end
    sum
  end
end

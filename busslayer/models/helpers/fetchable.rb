module Fetchable
  def fetch_hash(status_value = 200, values = [])
    hash = {}
    hash[:status] = status_value
    values.each do |value|
      hash[value] = self.send(value)
    end
    hash
  end
end
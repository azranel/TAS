class StatisticsHandler
  def fetch
    get_data
  end

  private

  def get_data
    hash = {
      tenants_count: Apartment.all_tenants_count,
      bills_value: Bill.all_bills_value,
      apartments: []
    }
    Apartment.all.each do |a|
      hash[:apartments] << [name: a.name, description: a.description,
                          tenants_count: a.users.count, bills_value: a.bills_value]
    end
    hash
  end
end

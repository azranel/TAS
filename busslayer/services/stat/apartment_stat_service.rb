module Stat
  class ApartmentStatService
    def fetch
      apartments, tenants_count, bills_value = get_data
      respond_with(apartments: apartments, tenants_count: tenants_count, 
        bills_value: bills_value)
    end

    private

    def get_data
      tenants_count = Apartment.all_tenants_count
      puts tenants_count
      bills_value = Bill.all_bills_value
      apartments = []
      Apartment.all.each do |a|
        apartments << ApartmentStat.new(name: a.name, description: a.description,
          tenants_count: a.users.count, bills_value: a.bills_value)
      end
      return [apartments, tenants_count, bills_value]
    end
  end
end
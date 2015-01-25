module Stat
  class ApartmentStatService
    def fetch
      respond_with(list)
    end

    private

    def get_data
      ApartmentsStatList list = ApartmentsStatList.new
      list.tenants_count = Apartment.all_tenants_count
      list.bills_value = Bill.all_bills_value
      Apartment.all.each do |a|
        list.apartments << ApartmentStat.new(name: a.name, description: a.description,
          tenants_count: a.users.count, bills_value: a.bills_value)
      end
      list
    end
  end
end
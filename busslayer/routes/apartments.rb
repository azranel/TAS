module Sinatra
  module Routing
    module Apartments
      def self.registered(app)
        fetch(app)
        delete(app)
        create(app)
        update(app)
        bills(app)
        add_resident(app)
      end

      def self.fetch(app)
        app.get  '/apartments/:id' do
          content_type :json
          a = Apartment.find_by_id(params[:id])
          if a
            messages = a.messages
            user_bills_list = []
            a.bills.each do |bill|
              bill_hash = {}
              bill_hash['users'] = []
              bill_hash['users_ids'] = []
              bill.users.each do |user|
                user_data = {
                  'id' => user.id,
                  'firstname' => user.firstname,
                  'lastname' => user.lastname
                }
                bill_hash['users'] << user_data
                bill_hash['users_ids'] << user.id
              end
              bill_hash['bill_id'] = bill.id
              user_bills_list << bill_hash
            end

            hash = { status: 200, id: a.id, name: a.name, address: a.address, city: a.city,
                     description: a.description, owner: a.user, residents: a.users, bills: a.bills,
                     user_bills_list: user_bills_list, residents_count: a.users.count,
                     messages: messages }.to_json(methods: :divide)
          else
            { status: 404 }.to_json
          end
        end
      end

      def self.delete(app)
        app.get  '/apartments/:id/delete' do
          content_type :json
          a = Apartment.find_by_id(params[:id])
          if a.delete
            { status: 200 }.to_json
          else
            { status: 404 }.to_json
          end
        end
      end

      def self.create(app)
        app.post '/apartments/create' do
          content_type :json
          a = Apartment.new(params[:apartment])
          if a.save
            { status: 200, id: a.id, created_at: a.created_at }.to_json
          else
            { status: 403 }.to_json
          end
        end
      end

      def self.update(app)
        app.post '/apartments/:id/update' do
          content_type :json
          a = Apartment.find_by_id(params[:id])
          if a
            if a.update(params[:apartment])
              { status: 200, updated_at: a.updated_at }.to_json
            else
              { status: 403 }.to_json
            end
          else
            { status: 404 }.to_json
          end
        end
      end

      def self.bills(app)
        app.get '/apartments/:id/bills' do
          bills = Apartment.find_by_id(params[:id]).bills
          bills.to_json
        end
      end

      def self.add_resident(app)
        app.post '/apartments/:id/addresident' do
          content_type :json
          adder = User.find_by_id(params[:adder_id])
          apartment = Apartment.find_by_id(params[:id])
          if apartment.have_owner_or_resident?(adder)
            resident = User.find_by_email(params[:email])
            unless apartment.have_resident?(resident)
              if resident
                apartment.users << resident
                apartment.save
                { status: 200 }.to_json
              else
                { status: 404 }.to_json
              end
            else
              { status: 403 }.to_json
            end
          end
        end
      end
    end
  end
end

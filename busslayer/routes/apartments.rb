module Sinatra
  module Routing
    module Apartments
      def self.registered(app)
        fetch(app)
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
            { status: 200, id: a.id, name: a.name, address: a.address, city: a.city, owner: a.user, residents: a.users }.to_json
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
        app.post '/apartments/update' do
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
          resident = User.find_by_id(params[:user_id])
          apartment = Apartment.find_by_id(params[:id])
          user = User.find_by_email(params[:email])
          apartment.users << user
          apartment.save
          { status: 200 }.to_json
          # if apartment.have_user?(resident)
          #   user = User.find_by_email(params[:email])
          #   if user
          #     apartment.users << user
          #     apartment.save
          #     { status: 200 }.to_json
          #   else
          #     { status: 404 }.to_json
          #   end
          # end
        end
      end
    end
  end
end

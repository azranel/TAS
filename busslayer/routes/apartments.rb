module Sinatra
  module Routing
    module Apartments
      def self.registered(app)

        app.get  '/apartments/:id' do
          content_type :json
          a = Apartment.find_by_id(params[:id])
          if a
            { status: 200, id: a.id, name: a.name, address: a.address, city: a.city, user_id: a.user_id, created_at: a.created_at, updated_at: a.updated_at }.to_json
          else
            { status: 404 }.to_json
          end
        end

        app.post "/apartments/create" do
          content_type :json
          a = Apartment.new(params[:apartment])
          if a.save
            { status: 200, id: a.id, created_at: a.created_at }.to_json
          else
            { status: 403}.to_json
          end

        app.post "/apartments/update" do
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
      end
    end
  end
end

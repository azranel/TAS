module Sinatra
  module Routing
    module Users
      def self.registered(app)
        register(app)
        login(app)
        fetch(app)
        bills(app)
      end

      def self.register(app)
        app.post "/users/register" do
          content_type :json
          u = User.new(params[:user])
          if u.save
            u.fetch_hash(200, [:id]).to_json
          else
            u.fetch_hash(403, []).to_json
          end
        end
      end

      def self.login(app)
        app.post "/users/login" do
          content_type :json
          u = User.find_by_email(params[:email])
          if u
            if u.authenticate(params[:password])
              u.fetch_hash(200, [:id]).to_json
            else
              u.fetch_hash(403, []).to_json
            end
          else
            # :fetch_hash cannot be used because of user if not found
            { status: 404 }.to_json
          end
        end
      end

      def self.fetch(app)
        app.get  '/users/:id' do
          content_type :json
          u = User.find_by_id(params[:id])
          if u
            hash = u.fetch_hash
            hash['owned'] = Apartment.where(user_id: u.id)

            hash['list_of_apartments'] = {}
            hash['apartments_info'] = []
            hash['apartments_ids'] = []
            u.bills.each do |bill|
              if bill.user_id != u.id
                user_data = {
                  'apartment_id' => bill.apartment_id,
                  'apartment_name' => Apartment.all.find_by_id(bill.apartment_id).name,
                  'value' => bill.divide,
                }
                hash['apartments_info'] << user_data
                hash['apartments_ids'] << bill.apartment_id
              end
            end
            hash['apartments_info'].each do |apartment|
              if hash['list_of_apartments'][apartment['apartment_id']].nil?
                hash['list_of_apartments'][apartment['apartment_id']] = {
                  'value' => apartment['value'],
                  'name' => apartment['apartment_name'],
                }
              else
                hash['list_of_apartments'][apartment['apartment_id']]['value'] += apartment['value']
              end
            end
            hash['list_of_apartments'] = hash['list_of_apartments'].to_a
            hash.to_json
          else
            { status: 404 }.to_json
          end
        end
      end

      def self.bills(app)
        app.get '/users/:id/bills' do
          bills = User.find_by_id(params[:id]).bills
          bills.to_json
        end
      end
    end
  end
end

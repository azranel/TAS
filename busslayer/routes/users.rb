module Sinatra
  module Routing
    module Users
      def self.registered(app)
        register(app)
        login(app)
        fetch(app)
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
            hash.to_json
          else
            { status: 404 }.to_json
          end
        end
      end
    end
  end
end

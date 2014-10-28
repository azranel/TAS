module Sinatra
  module Routing
    module Users
      def self.registered(app)

        app.get  '/users/:id' do
          content_type :json
          u = User.find_by_id(params[:id])
          if u
            u.fetch_hash.to_json
          else
            { status: 404 }.to_json
          end
        end

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
    end
  end
end

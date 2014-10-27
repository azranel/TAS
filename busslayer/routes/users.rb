module Sinatra
  module Routing
    module Users
      def self.registered(app)

        app.get  '/users/:id' do
          content_type :json
          u = User.find_by_id(params[:id])
          if u
            { status: 200, id: u.id, firstname: u.firstname, lastname: u.lastname, email: u.email, phone: u.phone }.to_json
          else
            { status: 404 }.to_json
          end
        end

        app.post "/users/login" do
          content_type :json
          u = User.find_by_email(params[:email])
          if u
            if u.authenticate(params[:password])
              { status: 200, id: u.id }.to_json
            else
              { status: 403 }.to_json
            end
          else
            { status: 404 }.to_json
          end
        end

        app.post "/users/register" do
          content_type :json
          u = User.new(params[:user])
          if u.save
            { status: 200, id: u.id }.to_json
          else
            { status: 403}.to_json
          end
        end
      end
    end
  end
end

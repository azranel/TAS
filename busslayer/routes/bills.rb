module Sinatra
  module Routing
    module Bills
      def self.registered(app)
        fetch(app)
      end

      def self.fetch(app)
        app.get "/bills/:id" do
          content_type :json
          bill = Bill.find_by_id(params[:id])
          if bill
            bill.fetch_hash(200, 
              [:name, :description,:value,
              :apartment_id, :user_id]).to_json
          else
            { status: 404 }.to_json
          end
        end
      end

    end
  end
end
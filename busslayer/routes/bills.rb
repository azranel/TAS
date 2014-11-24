module Sinatra
  module Routing
    module Bills
      def self.registered(app)
        fetch(app)
        create(app)
        delete(app)
      end

      def self.fetch(app)
        app.get "/bills/:id" do
          content_type :json
          bill = Bill.find_by_id(params[:id])
          if bill
            h = bill.fetch_hash(200,
                                [:name, :description,:value,
                                 :apartment_id, :user_id])
            h['divided'] = bill.divide(bill.apartment.users.count)
            h.to_json
          else
            { status: 404 }.to_json
          end
        end
      end

      def self.create(app)
        app.post "/bills/create" do
          content_type :json
          bill = Bill.new(params[:bill])
          if bill.valid?
            bill.save
            h = bill.fetch_hash(201, [:id])
          else
            h = bill.fetch_hash(404)
          end
          h.to_json
        end
      end

      def self.delete(app)
        app.delete '/bills/:id' do
          bill = Bill.find_by_id(params[:id])
          if bill
            { status: 200 }.to_json if bill.delete
          else
            { status: 404 }.to_json
          end
        end
      end

    end
  end
end

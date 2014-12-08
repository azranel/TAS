module Sinatra
  module Routing
    module Bills
      def self.registered(app)
        fetch(app)
        create(app)
        update(app)
        delete(app)
        add_debtor(app)
        delete_debtor(app)
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

      def self.update(app)
        app.post '/bills/:id/edit' do
          content_type :json
          bill = Bill.find_by_id(params[:id])
          if bill
            bill.update(params[:bill])
            { status: 200, apartment_id: bill.apartment_id }.to_json
          else
            { status: 404 }.to_json
          end
        end
      end

      def self.delete(app)
        app.delete '/bills/:id' do
          content_type :json
          bill = Bill.find_by_id(params[:id])
          if bill
            { status: 200, apartment_id: bill.apartment_id }.to_json if bill.delete
          else
            { status: 404 }.to_json
          end
        end
      end

      def self.add_debtor(app)
        app.post '/bills/:id/adddebtor' do
          content_type :json
          debtor = User.find_by_id(params[:user_id])
          bill = Bill.find_by_id(params[:id])
          bill.users << debtor
          bill.save
          { status: 200 }.to_json
        end
      end

      def self.delete_debtor(app)
        app.post '/bills/:id/deletedebtor' do
          content_type :json
          bill = Bill.find_by_id(params[:id])
          if bill
            { status: 404, apartment_id: bill.apartment_id }.to_json
            { status: 200, apartment_id: bill.apartment_id }.to_json if bill.users.delete(bill.users.find_by_id(params[:debtor_id]))
          else
            { status: 404, apartment_id: bill.apartment_id }.to_json
          end
        end
      end
    end
  end
end

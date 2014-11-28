require File.expand_path '../helpers/spec_helper.rb', __FILE__

describe 'Bills routes' do
  describe 'GET /bills/:id' do
    context 'if not found' do
      before :all do
        @response = get 'bills/-1'
        @response = JSON.parse(@response.body)
      end
      it 'returns 404' do
        expect(@response['status']).to eq(404)
      end

      it "doesn't returns message" do
        expect(@response['message']).to be_nil
      end
    end

    context 'if found' do
      before :all do
        @bill = create(:bill)
        @response = get "/bills/#{ @bill.id }"
        @response = JSON.parse(@response.body)
      end

      it 'returns 200' do
        expect(@response['status']).to eq(200)
      end

      it 'returns name' do
        expect(@response['name']).to eq(@bill.name)
      end

      it 'returns description' do
        expect(@response['description']).to eq(@bill.description)
      end

      it 'returns value' do
        expect(@response['value']).to eq(@bill.value)
      end

      it 'returns apartment id' do
        expect(@response['apartment_id']).to eq(@bill.apartment.id)
      end

      it 'returns owner id' do
        expect(@response['user_id']).to eq(@bill.owner.id)
      end
    end

  end

  describe 'POST /bills/create' do
    context 'params are not correct' do
      before :all do
        @response = post '/bills/create', bill:
          { name: 'Rachunki za zakupy',
            description: 'Nowe rachunki' }
          # puts @response.body.to_s
          @response = JSON.parse(@response.body)
      end

      it 'returns 404 status' do
        expect(@response['status']).to eq(404)
      end

      it 'does not return message' do
        expect(@response['message']).to be_nil
      end
    end

    context 'params are correct' do
      before :all do
        user = create(:user)
        apartment = create(:apartment)
        @response = post '/bills/create', bill:
          { name: 'Mop', description: 'Takie tam',
            value: 35.99, apartment_id: apartment.id,
            user_id: user.id }
          @response = JSON.parse(@response.body)
      end

      it 'should have status 201' do
        expect(@response['status']).to eq(201)
      end

      it 'should have bill id' do
        expect(@response['id']).not_to be_nil
      end

    end
  end

  describe 'DELETE /bills/:id' do
    context 'if not found' do
      before :all do
        @response = delete 'bills/-1'
        @response = JSON.parse(@response.body)
      end

      it 'returns 404 status' do
        expect(@response['status']).to eq(404)
      end

      it 'does not return message' do
        expect(@response['message']).to be_nil
      end
    end

    context 'if found' do
      before :all do
        @bill = create(:bill)
        @response = delete "/bills/#{ @bill.id }"
        @response = JSON.parse(@response.body)
      end

      it 'should return 200' do
        expect(@response['status']).to eq(200)
      end
    end
  end
end

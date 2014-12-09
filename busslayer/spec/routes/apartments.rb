require File.expand_path '../helpers/spec_helper.rb', __FILE__

describe "Apartments routes" do
  before :all do
    unless @a = Apartment.find_by_id(0)
      @a = Apartment.create(name: "Bols", address: "Boleslawa 25b/14", city: "Poznan", description: "test")
    end
  end

  describe "GET /apartments/:id" do
    context "if not found" do
      it "returns 404 if apartment is not found" do
        response = get "apartments/-1"
        expect(response.body).to include({ status: 404 }.to_json)
      end
    end

    context "if found" do
      before :all do
        response = get "apartments/#{@a.id}"
        @response = JSON.parse(response.body)
      end

      it "returns apartment data if found" do
        expect(@response['id']).to eq(@a.id)
      end

      it "returns status 200 in JSON" do
        expect(@response["status"]).to eq(200)
      end
    end
  end

  describe "POST /apartments/create" do
    context "if apartment is created" do
      before :all do
        response = post "apartments/create", apartment: { name: "Rusek", address: "Rusa 121/11", city: "Poznan", description: "testowy test" }
        @response = JSON.parse(response.body)
      end

      it "return status 200 in JSON" do
        expect(@response["status"]).to eq(200)
      end

      it "return apartment id" do
        expect(@response["id"]).not_to be_nil
      end
    end

    context "if apartment is not created" do
      before :all do
        response = post "apartments/create"
        @response = JSON.parse(response.body)
      end

      it "return 403 in JSON" do
        expect(@response["status"]).to eq(403)
      end
    end
  end

  describe "POST /apartments/:id/update" do
    context "if apartment doesn't exist" do
      it "returns 404 if apartment is not found" do
        response = post 'apartments/update', apartment: { name: "Bols", address: "Boleslawa 25b/14", city: "Torun", description: "test" }
        @response = JSON.parse(response.body)
      end
    end

    context "if apartment exist" do
      before :all do
        response = get "apartments/#{@a.id}"
        @response = JSON.parse(response.body)
      end

      it "returns apartment data if found" do
        expect(@response['id']).to eq(@a.id)
      end

      it "returns status 200 in JSON" do
        expect(@response["status"]).to eq(200)
      end
    end
  end

  describe "GET /apartments/:id/delete" do
    context "if apartment is deleted" do
      before :all do
        response = get "apartments/#{@a.id}/delete"
        @response = JSON.parse(response.body)
      end

      it "return status 200 in JSON" do
        expect(@response["status"]).to eq(200)
      end
    end

    context "if apartment is not deleted" do
      before :all do
        response = post "apartments/-1/delete"
        @response = JSON.parse(response.body)
      end

      it "return 404 in JSON" do
        expect(@response["status"]).to eq(404)
      end
    end
  end
end
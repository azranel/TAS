require File.expand_path '../helpers/spec_helper.rb', __FILE__

describe "Users routes" do
  before :all do
    unless @u = User.find_by_email("monko@gmail.com")
      @u = User.create(firstname: 'Monika', lastname: 'Kowalik', email: 'monko@gmail.com', password: 'alalubikotybardzo', phone: '854154673')
    end
  end

  describe "GET /users/:id" do
    context "if not found" do
      it "returns 404 if user is not found" do
        response = get 'users/-1'
        expect(response.body).to include({ status: 404 }.to_json)
      end
    end

    context "if found" do
      before :all do
        response = get "users/#{@u.id}"
        @response = JSON.parse(response.body)
      end

      it "returns user data if found" do
        expect(@response["id"]).to eq(@u.id)
      end

      it "returns status 200 in JSON" do
        expect(@response["status"]).to eq(200)
      end
    end
  end

  describe "POST /users/login" do
    context "if user is found and password is good" do
      before :all do
        response = post "/users/login", { email: @u.email, password: 'alalubikotybardzo'}
        @response = JSON.parse(response.body)
      end

      it "returns status 200 in JSON" do
        expect(@response["status"]).to eq(200)
      end

      it "returns user id" do
        expect(@response["id"]).to eq(@u.id)
      end
    end

    context "if user is found but password is wrong" do
      before :all do
        response = post "users/login", { email: @u.email, password: 'lolicoztego' }
        @response = JSON.parse(response.body)
      end

      it "return status 403 in JSON" do
        expect(@response["status"]).to eq(403)
      end
    end

    context "if user is not found" do
      before :all do
        response = post "users/login", { email: "terazjusz1234@vp.pl", password: "lolicoztego" }
        @response = JSON.parse(response.body)
      end

      it "returns status 404 in JSON" do
        expect(@response["status"]).to eq(404)
      end
    end
  end

  describe "POST /users/register" do
    context "if user is registered" do
      before :all do
        response = post "users/register", user: { firstname: "Janusz", lastname: "Terlakowski", email: "janter@op.pl", password: "kucykpony123", phone: "123456789" }
        @response = JSON.parse(response.body)
      end

      it "return status 200 in JSON" do
        expect(@response["status"]).to eq(200)
      end

      it "return user id" do
        expect(@response["id"]).not_to be_nil
      end
    end

    context "if user is not registered" do
      before :all do
        response = post "users/register"
        @response = JSON.parse(response.body)
      end

      it "return 403 in JSON" do
        expect(@response["status"]).to eq(403)
      end
    end

  end
end
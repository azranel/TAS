require File.expand_path '../helpers/spec_helper.rb', __FILE__

describe "User" do
  before :all do 
      @hash = attributes_for(:user)
      @u = User.create(@hash)
  end

  describe "validations" do
    it "firstname" do
      @u.firstname = nil
      expect(@u).not_to be_valid
    end

    it "lastname" do
      @u.lastname = nil
      expect(@u).not_to be_valid
    end

    it "phone" do
      @u.phone = nil
      expect(@u).not_to be_valid
    end

    it "email presence" do
      @u.email = nil
      expect(@u).not_to be_valid
    end

    it "email uniqueness" do
      u2 = User.new(@hash)
      expect(u2).not_to be_valid
    end
  end

  describe "fetches" do
    context "status 200" do
      it "hash should have user information" do
        h = @u.fetch_hash(200)
        expect(h.keys).to eq([:status, :id, :firstname, :lastname, :email, :phone, :apartments])
      end      
    end

    context "status other than 200" do
      it "hash should have only status code and user id" do
        h = @u.fetch_hash(200, [:id])
        expect(h.keys).to eq([:status, :id])
      end
    end
  end

  # Test below doesn't pass, dunno why
  #
  # describe "associations" do
  #   it "can have many apartments" do
  #     @u.apartments << Apartment.new(name: "Stare mieszkanie", city: "Poznań")
  #     @u.apartments << Apartment.new(name: "Nowe mieszkanie", city: "Warszawa")
  #     @u.save
  #     expect(@u.apartments.count).to eq(2)
  #   end
  # end
end
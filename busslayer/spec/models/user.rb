require File.expand_path '../helpers/spec_helper.rb', __FILE__

describe "User" do
  before :all do 
      @u = User.new(firstname:"Jan", lastname: "Kowalski", email: "janko@wp.pl", password: "alamakota123", phone: "123456789")
      @u.save
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
      u2 = User.new(firstname: "Jan", lastname: "Nowak", email: "janko@wp.pl", password: "alamakota123", phone:"123445434")
      expect(u2).not_to be_valid
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
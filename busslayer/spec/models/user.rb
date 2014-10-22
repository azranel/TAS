require File.expand_path '../helpers/spec_helper.rb', __FILE__

describe "User" do
  describe "validations" do
    before :all do 
      @u = User.new(firstname:"Jan", lastname: "Kowalski", email: "janko@wp.pl", password: "alamakota123", phone: "123456789")
    end

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
      @u.save
      u2 = User.new(firstname: "Jan", lastname: "Nowak", email: "janko@wp.pl", password: "alamakota123", phone:"123445434")
      count = User.count
      u2.save
      expect(User.count).to eq(count)
    end
  end
end
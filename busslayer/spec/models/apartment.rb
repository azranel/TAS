require File.expand_path '../helpers/spec_helper.rb', __FILE__

describe "Apartment" do
  describe "validations" do
    before :all do
      @a = create(:apartment)
    end

    it "name" do
      @a.name = nil
      expect(@a).not_to be_valid
    end

    it "address" do
      @a.address = nil
      expect(@a).not_to be_valid
    end

    it "city" do
      @a.city = nil
      expect(@a).not_to be_valid
    end

    it "user_id" do
      @a.user_id = nil
      expect(@a).not_to be_valid
    end

    it "description" do
      @a.description = nil
      expect(@a).not_to be_valid
    end
  end
end
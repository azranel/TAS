require File.expand_path '../helpers/spec_helper.rb', __FILE__

describe 'Bill' do
  before :all do
    user = User.create(firstname: 'Jan', lastname:'Kowalski',
      email:'janko@wp.pl',password:'alamakota',phone:'666174555')
    apartment = Apartment.create(name:'BOLS',description:'Takie tam',
      address:'Chrobrego 13a/4', city: 'Poznań')
    @b = Bill.create(name: 'Rachunek za gaz i prąd', 
      description: 'Taki tam rachunek heheszki',
      value: 154.69, owner: user, apartment: apartment)
  end

  describe 'validations' do
    it 'should have name' do
      @b.name = nil
      expect(@b).not_to be_valid
    end

    it 'should have value' do
      @b.value = nil
      expect(@b).not_to be_valid
    end

    it 'should be pinned to apartment' do
      @b.apartment = nil
      expect(@b).not_to be_valid
    end

    it 'should have owner' do
      @b.owner = nil
      expect(@b).not_to be_valid
    end

    it 'cant have value with 3 decimal places' do
      @b.value = 3.562
      expect(@b).not_to be_valid
    end
  end

  describe '#divide' do
    it '2.49 by 4 should equal 0.62' do
      @b.value = 2.49
      expect(@b.divide(4)).to eq(0.62)
    end

    it '3.59 by 2 should equal 1.80' do
      @b.value = 3.59
      expect(@b.divide(2)).to eq(1.80)
    end
  end
end
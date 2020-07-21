require 'rails_helper'

RSpec.describe Customer, type: :model do
  context 'relationships' do
    it { is_expected.to have_many :carts }
  end

  context "name" do
    let(:test) { Customer.new(name: 'test') }
    it "first letter is always capitalized" do
      test.save
      expect(test.name).to eq('Test') 
    end
  end
  
end

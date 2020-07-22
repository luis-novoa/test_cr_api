require 'rails_helper'

RSpec.describe Customer, type: :model do
  context 'relationships' do
    it { is_expected.to have_many :carts }
  end

  context '.name' do
    subject { Customer.new(name: 'test') }
    it 'first letter is always capitalized' do
      subject.save
      expect(subject.name).to eq('Test') 
    end

    it 'first letter is always capitalized for more than one word' do
      subject.name = 'another test'
      subject.save
      expect(subject.name).to eq('Another Test') 
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50) }
  end
  
end

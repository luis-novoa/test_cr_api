require 'rails_helper'

RSpec.describe Medicine, type: :model do
  let(:valid_attributes) { { name: 'Aspirina', value: 10.0, quantity: 1, stock: 10 } }
  subject { Medicine.new(valid_attributes) }

  context "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50) }

    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_numericality_of(:value).is_greater_than_or_equal_to(0) }

    it { is_expected.to validate_presence_of(:stock) }
    it { is_expected.to validate_numericality_of(:stock).is_greater_than_or_equal_to(0) }
  end

  context '.name' do
    it 'first letter is always capitalized' do
      subject.name = 'test'
      subject.save
      expect(subject.name).to eq('Test') 
    end

    it 'first letter is always capitalized for more than one word' do
      subject.name = 'another test'
      subject.save
      expect(subject.name).to eq('Another Test') 
    end
  end

  context '#total' do
    it 'multiplies' do
      expect(subject.total).to eql 10.0
    end
  end
end

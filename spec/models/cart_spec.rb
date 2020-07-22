require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'relationships' do
    it { is_expected.to belong_to :customer }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:customer_id) }
    it { is_expected.to validate_numericality_of(:customer_id).is_greater_than(0) }
  end
  
end

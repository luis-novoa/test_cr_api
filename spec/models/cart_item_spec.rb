require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context 'relationships' do
    it { is_expected.to belong_to :cart }
    it { is_expected.to belong_to :medicine }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:cart_id) }
    it { is_expected.to validate_numericality_of(:cart_id).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:medicine_id) }
    it { is_expected.to validate_numericality_of(:medicine_id).is_greater_than(0) }
  end
end

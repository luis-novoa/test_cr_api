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
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
  end

  # context '#check_medicine_stock' do
  #   let(:customer) { Customer.create(name: 'test') }
  #   let(:medicine) { Medicine.create(name: 'Test1', value: 1, quantity: 1, stock: 0) }
  #   let(:cart) { customer.carts.build }

  #   it 'stop creation if medicine.stock == 0' do
  #     cart.save
  #     CartItem.create(cart_id: cart.id, medicine_id: medicine.id, quantity: 1)
  #     expect().to  
  #   end
  # end
end

require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'relationships' do
    it { is_expected.to belong_to :customer }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:customer_id) }
    it { is_expected.to validate_numericality_of(:customer_id).is_greater_than(0) }
  end

  context "#total" do
  let(:customer) { Customer.create(name: 'test') }
  let(:medicine) { Medicine.create(name: 'Test1', value: 1, quantity: 1, stock: 1) }
  let(:medicine2) { Medicine.create(name: 'Test2', value: 10, quantity: 1, stock: 1) }
  let(:cart) { customer.carts.build }

    it 'calculates sum of all items of the cart' do
      cart.save
      CartItem.create(cart_id: cart.id, medicine_id: medicine.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine2.id, quantity: 1)
      expect(cart.total).to eq(11)
    end
  end
end

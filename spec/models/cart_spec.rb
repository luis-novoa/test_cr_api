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
  let(:medicine) { Medicine.create(name: 'Test1', value: 1, quantity: 1, stock: 10) }
  let(:medicine2) { Medicine.create(name: 'Test2', value: 1, quantity: 1, stock: 10) }
  let(:medicine3) { Medicine.create(name: 'Test3', value: 1, quantity: 1, stock: 10) }
  let(:medicine4) { Medicine.create(name: 'Test4', value: 1, quantity: 1, stock: 10) }
  let(:medicine5) { Medicine.create(name: 'Test5', value: 1, quantity: 1, stock: 10) }
  let(:cart) { Cart.create(customer_id: customer.id) }

    it "doesn't apply discount on repeated items" do
      CartItem.create(cart_id: cart.id, medicine_id: medicine.id, quantity: 5)
      expect(cart.total).to eq(5)
    end

    it 'applies discount of 5% on two distinct items' do
      CartItem.create(cart_id: cart.id, medicine_id: medicine.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine2.id, quantity: 1)
      expect(cart.total).to eq(1.9)
    end

    it 'applies discount of 10% on three distinct items' do
      CartItem.create(cart_id: cart.id, medicine_id: medicine.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine2.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine3.id, quantity: 1)
      expect(cart.total).to eq(2.7)
    end

    it 'applies discount of 20% on four distinct items' do
      CartItem.create(cart_id: cart.id, medicine_id: medicine.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine2.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine3.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine4.id, quantity: 1)
      expect(cart.total).to eq(3.2)
    end

    it 'applies discount of 25% on five distinct items' do
      CartItem.create(cart_id: cart.id, medicine_id: medicine.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine2.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine3.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine4.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine5.id, quantity: 1)
      expect(cart.total).to eq(3.75)
    end

    it 'groups items to offer the best discounts' do
      CartItem.create(cart_id: cart.id, medicine_id: medicine.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine2.id, quantity: 1)
      CartItem.create(cart_id: cart.id, medicine_id: medicine3.id, quantity: 2)
      CartItem.create(cart_id: cart.id, medicine_id: medicine4.id, quantity: 2)
      CartItem.create(cart_id: cart.id, medicine_id: medicine5.id, quantity: 2)
      expect(cart.total).to eq(6.4)
    end

    it 'can handle empty carts' do
      expect(cart.total).to eq(0)
    end
  end
end

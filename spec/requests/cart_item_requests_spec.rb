require 'rails_helper'

RSpec.describe 'Cart request', type: :request do
  let(:customer) { Customer.create(name: 'test') }
  let(:medicine) { Medicine.create(name: 'Test1', value: 1, quantity: 1, stock: 1) }

  describe 'POST api/cart_items' do
    let(:cart) { customer.carts.build }

    context 'with invalid cart id' do
      before(:each) do
        parameters = {
          cart_item: {
            cart_id: 1,
            medicine_id: medicine.id,
            quantity: 1
          }
        }
        post '/api/cart_items', params: parameters
      end

      it 'responds with 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns errors' do
        expect(response.body).to match(/This cart doesn't exist./)
      end
    end

    context 'with invalid medicine id' do
      before(:each) do
        parameters = {
          cart_item: {
            cart_id: 1,
            medicine_id: 1,
            quantity: 1
          }
        }
        post '/api/cart_items', params: parameters
      end

      it 'responds with 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns errors' do
        expect(response.body).to match(/This medicine doesn't exist./)
      end
    end

    context 'with valid cart id' do
      before(:each) do
        cart.save
        parameters = {
          cart_item: {
            cart_id: cart.id,
            medicine_id: medicine.id,
            quantity: 1
          }
        }
        post '/api/cart_items', params: parameters
      end

      it 'responds with 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns succesful message' do
        expect(response.body).to match(/#{medicine.name} added to cart #{cart.id}./)
      end

      it 'deduces quantity from medicine stock' do
        expect(Medicine.find(medicine.id).stock).to eq(0)
      end
    end

    context 'with quantity bigger than stock' do
      before(:each) do
        cart.save
        parameters = {
          cart_item: {
            cart_id: cart.id,
            medicine_id: medicine.id,
            quantity: 10
          }
        }
        post '/api/cart_items', params: parameters
      end

      it 'responds with 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns error' do
        expect(response.body).to match(/Not enough #{medicine.name} in stock!/)
      end

      it 'cancel item addition' do
        expect(cart.cart_items.count).to eq(0)
      end
    end
  end

  describe 'DELETE api/cart_items/:id' do
    let(:cart) { Cart.create(customer_id: customer.id) }
    let(:cart_item) { CartItem.new(cart_id: cart.id, medicine_id: medicine.id, quantity: 1) }

    context 'with invalid cart_item id' do
      before(:each) { delete '/api/cart_items/1' }

      it 'responds with 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns errors' do
        expect(response.body).to match(/This cart item doesn't exist./)
      end
    end

    context 'with valid cart_item id' do
      before(:each) do
        cart_item.save
        delete "/api/cart_items/#{cart_item.id}"
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns succesful message' do
        expect(response.body).to match(/#{medicine.name} removed from cart #{cart.id}./)
      end

      it 'returns quantity to the medicine stock' do
        expect(Medicine.find(medicine.id).stock).to eq(2)
      end
    end
  end
end

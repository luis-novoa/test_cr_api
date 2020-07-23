require 'rails_helper'

RSpec.describe 'Cart request', type: :request do
  describe 'POST api/cart_items' do
    let(:customer) { Customer.create(name: 'test') }
    let(:medicine) { Medicine.create(name: 'Test1', value: 1, quantity: 1, stock: 1) }
    let(:medicine2) { Medicine.create(name: 'Test2', value: 1, quantity: 1, stock: 1) }
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
        CartItem.create(cart_id: cart.id, medicine_id: medicine2.id, quantity: 1)
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

      it 'returns list of items in the cart' do
        expect(response.body).to match(/\"medicine_id\":#{medicine.id}/).and match(/\"medicine_id\":#{medicine2.id}/)
      end

      it 'returns new sum of items in the cart' do
        expect(response.body).to match(/\"total\":2/)
      end
    end
  end

  # describe 'DELETE api/carts/:id' do
  #   context 'with invalid cart id' do
  #     before(:each) { delete '/api/cart_items/1' }

  #     it 'responds with 404' do
  #       expect(response).to have_http_status(404)
  #     end

  #     it 'returns errors' do
  #       expect(response.body).to match(/This cart doesn't exist./)
  #     end
  #   end

  #   context 'with valid cart id' do
  #     let(:customer) { Customer.create(name: 'test') }
  #     let(:cart) { customer.carts.build }
  #     before(:each) do
  #       cart.save
  #       delete "/api/cart_items/#{cart.id}"
  #     end

  #     it 'responds with 200' do
  #       expect(response).to have_http_status(200)
  #     end

  #     it 'deletes cart' do
  #       expect(Cart.count).to eq(0)
  #     end

  #     it 'returns succesful message' do
  #       expect(response.body).to match(/Cart #{cart.id} was deleted!/)
  #     end
  #   end
  # end
end
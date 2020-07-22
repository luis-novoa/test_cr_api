require 'rails_helper'

RSpec.describe 'Cart request', type: :request do
  describe 'POST api/carts' do
    context 'with invalid id' do
      before(:each) do
        parameters = {
          cart: {
            customer_id: 1
          }
        }
        post '/api/carts', params: parameters
      end

      it 'responds with 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns errors' do
        expect(response.body).to match(/This customer doesn't exist./)
      end
    end

    context 'with valid id' do

      let(:customer) { Customer.create(name: 'test') }
      before(:each) do
        parameters = {
          cart: {
            customer_id: customer.id
          }
        }
        post '/api/carts', params: parameters
      end

      it 'responds with 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns cart information' do
        cart_id = Cart.first.id
        expect(response.body).to match(/\"id\":#{cart_id}/)
      end
    end
  end
end

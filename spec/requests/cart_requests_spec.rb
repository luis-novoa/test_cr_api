require 'rails_helper'

RSpec.describe 'Cart request', type: :request do
  describe 'POST api/carts' do
    context 'with invalid customer id' do
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

    context 'with valid customer id' do
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

  describe 'GET /api/carts' do
    context 'with registered carts' do
      let(:customer) { Customer.create(name: 'Test') }
      before(:each) do
        customer.carts.build.save
        customer.carts.build.save
        get '/api/carts'
      end
      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns list of carts' do
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
      end

      it "informs carts' ids" do
        expect(response.body).to match(/id/)
      end
    end

    context 'without registered carts' do
      before(:each) { get '/api/carts' }

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns warning' do
        expect(response.body).to match(/No carts registered yet!/)
      end
    end
  end

  describe 'DELETE api/carts/:id' do
    context 'with invalid cart id' do
      before(:each) { delete '/api/carts/1' }

      it 'responds with 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns errors' do
        expect(response.body).to match(/This cart doesn't exist./)
      end
    end

    context 'with valid cart id' do
      let(:customer) { Customer.create(name: 'test') }
      let(:cart) { customer.carts.build }
      before(:each) do
        cart.save
        delete "/api/carts/#{cart.id}"
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'deletes cart' do
        expect(Cart.count).to eq(0)
      end

      it 'returns succesful message' do
        expect(response.body).to match(/Cart #{cart.id} was deleted!/)
      end
    end
  end
end

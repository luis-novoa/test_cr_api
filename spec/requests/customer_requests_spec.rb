require 'rails_helper'

RSpec.describe 'Customer request', type: :request do
  describe 'POST api/customers' do
    context 'with invalid name' do
      before(:each) do
        parameters = {
          customer: {
            name: 'test'
          }
        }
        Customer.create(name: 'Test')
        post '/api/customers', params: parameters
      end
      it 'responds with 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns errors' do
        expect(response.body).to match(/name/)
      end
    end

    context 'with correct information' do
      before(:each) do
        parameters = {
          customer: {
            name: 'test'
          }
        }
        post '/api/customers', params: parameters
      end

      it 'responds with 201' do
        expect(response).to have_http_status(201)
      end

      it 'creates new customer' do
        expect(Customer.count).to eq(1)
      end

      it 'returns new customer information' do
        expect(response.body).to match(/Test/)
      end
    end
  end

  describe 'GET /api/customers' do
    context 'with registered customers' do
      before(:each) do
        Customer.create(name: 'Test')
        Customer.create(name: 'Test1')
        get '/api/customers'
      end
      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns list of customers' do
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
      end
    end

    context 'without registered customers' do
      before(:each) do
        get '/api/customers'
      end
      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns warning' do
        expect(response.body).to match(/No customers registered yet!/)
      end
    end
  end
end
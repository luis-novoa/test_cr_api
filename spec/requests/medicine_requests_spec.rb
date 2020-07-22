require 'rails_helper'

RSpec.describe 'Medicine request', type: :request do
  describe 'POST api/medicines' do
    context 'with invalid name' do
      before(:each) do
        parameters = {
          medicine: {
            name: 'test',
            value: 1,
            quantity: 1,
            stock: 1
          }
        }
        Medicine.create(name: 'Test', value: 1, quantity: 1, stock: 1)
        post '/api/medicines', params: parameters
      end

      it 'responds with 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns errors' do
        expect(response.body).to match(/has already been taken/)
      end
    end

    context 'with correct information' do
      before(:each) do
        parameters = {
          medicine: {
            name: 'test',
            quantity: 1, 
            value: 1,
            stock: 1
          }
        }
        post '/api/medicines', params: parameters
      end

      it 'responds with 201' do
        expect(response).to have_http_status(201)
      end

      it 'creates new medicine' do
        expect(Medicine.count).to eq(1)
      end

      it 'returns new medicine information' do
        expect(response.body).to match(/Test/)
      end

      it "informs new medicine's ids" do
        expect(response.body).to match(/id/)
      end
    end
  end

  describe 'GET /api/medicines/:id' do
    context 'with existing medicine id' do
      before(:each) do
        medicine = Medicine.create(name: 'Test', value: 1, quantity: 1, stock: 1)
        get "/api/medicines/#{medicine.id}"
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it "returns medicine's information" do
        expect(response.body).to match(/Test/)
      end
    end

    context 'with inexistent medicine id' do
      before(:each) { get '/api/medicines/1' }

      it "responds with 404" do
        expect(response).to have_http_status(404)
      end

      it 'returns warning' do
        expect(response.body).to match(/This medicine doesn't exist./)
      end
    end
  end

  describe 'GET /api/medicines' do
    context 'with registered medicines' do
      before(:each) do
        Medicine.create(name: 'Test', value: 1, quantity: 1, stock: 1)
        Medicine.create(name: 'Test1', value: 1, quantity: 1, stock: 1)
        get '/api/medicines'
      end
      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns list of medicines' do
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
      end

      it "informs medicines' ids" do
        expect(response.body).to match(/id/)
      end
    end

    context 'without registered medicines' do
      before(:each) { get '/api/medicines' }

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns warning' do
        expect(response.body).to match(/No medicines registered yet!/)
      end
    end
  end

  describe 'PUT /api/medicines/:id' do
    context 'with existing medicine id' do
      context "and correct information" do
        before(:each) do
          medicine = Medicine.create(name: 'test', value: 1, quantity: 1, stock: 1)
          parameters = {
            medicine: {
              stock: 10
            }
          }
          put "/api/medicines/#{medicine.id}", params: parameters
        end
  
        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end
  
        it 'changes medicine information' do
          expect(Medicine.find_by(name: 'Test').stock).to eq(10)
        end
  
        it 'returns modified medicine' do
          expect(response.body).to match(/\"stock\":10/)
        end
      end
      
      context "and wrong information" do
        before(:each) do
          medicine = Medicine.create(name: 'test', value: 1, quantity: 1, stock: 1)
          parameters = {
            medicine: {
              stock: -1
            }
          }
          put "/api/medicines/#{medicine.id}", params: parameters
        end

        it 'responds with 422' do
          expect(response).to have_http_status(422)
        end
  
        it 'returns errors' do
          expect(response.body).to match(/must be greater than or equal to 0/)
        end
      end
    end

    context 'with inexistent medicine id' do
      before(:each) { put '/api/medicines/1' }

      it "responds with 404" do
        expect(response).to have_http_status(404)
      end

      it 'returns warning' do
        expect(response.body).to match(/This medicine doesn't exist./)
      end
    end
  end

  describe 'DELETE /api/medicines/:id' do
    context 'with existing medicine id' do
      before(:each) do
        medicine = Medicine.create(name: 'test', value: 1, quantity: 1, stock: 1)
        delete "/api/medicines/#{medicine.id}"
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'deletes medicine' do
        expect(Medicine.find_by(name: 'Test')).to eq(nil)
      end

      it 'returns succesful message' do
        expect(response.body).to match(/Test was deleted!/)
      end
    end

    context 'with inexistent medicine id' do
      before(:each) do
        delete '/api/medicines/1'
      end

      it "responds with 404" do
        expect(response).to have_http_status(404)
      end

      it 'returns warning' do
        expect(response.body).to match(/This medicine doesn't exist./)
      end
    end
  end
end
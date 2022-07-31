require 'rails_helper'
RSpec.describe ConnectionsController, type: :controller do
  let!(:user) { User.create! email: 'test@mail.com', password: 'password' }
  let!(:customer) { user.customers.create! id: '1' }
  let!(:connection) { customer.connections.create! connection_string_id: '1111' }

  describe '#index' do
    it 'should return a customer' do
      params = { 'customer_id' => customer.id }

      get :index, params: params

      expect(assigns[:customer]).to eq(customer)
    end
  end

  describe '#new' do
    it 'should get the connection for the new connection form' do
      params = { 'customer_id' => customer.id }

      post :new, params: params

      expect(assigns[:customer]).to eq(customer)
      expect(assigns[:connection][:customer_id]).to eq(customer.id)
    end
  end

  describe '#create' do
    let!(:params) { { 'customer_id' => customer.id.to_s, 'country_code' => 'XF', 'provider_code' => 'fake_bank_xf' } }

    it 'redirects to new page because the connection already exists in db' do
      expect(ConnectionsHelper)
        .to receive(:find_connection_in_db)
        .with(params)
        .and_return(connection)

      post :create, params: { customer_id: customer.id, connection: params }, body: params

      expect(subject).to redirect_to 'http://test.host/customers/1/connections/new'
      expect(subject.request.flash['alert']).to eq("Connection with Id = '1111' already exists")
    end

    it 'redirects to new page because the connection already exists in api response' do
      data = {
        'error' => {
          'message' => "Connection with identifier '1111' already exists"
        }
      }
      expect(ConnectionsHelper)
        .to receive(:find_connection_in_db)
        .with(params)
        .and_return(nil)

      expect(ApiHelper)
        .to receive(:create_connection)
        .with(customer.customer_string_id, params['country_code'], params['provider_code'])
        .and_return(data)

      post :create, params: { customer_id: customer.id, connection: params }, body: params

      expect(subject).to redirect_to 'http://test.host/customers/1/connections/new'
      expect(subject.request.flash['alert']).to eq(data['error']['message'])
    end

    it 'create new connection with accounts and transactions' do
      response = {
        'data' => {
          'id' => '1111'
        }
      }

      expect(ConnectionsHelper)
        .to receive(:find_connection_in_db)
        .with(params)
        .and_return(nil)

      expect(ApiHelper)
        .to receive(:create_connection)
        .with(customer.customer_string_id, params['country_code'], params['provider_code'])
        .and_return(response)

      expect(ConnectionsHelper)
        .to receive(:create_connection_with_api_result_data)
        .with(customer.id, response)
        .and_return(true)

      expect(AccountsHelper)
        .to receive(:create_update_accounts_for_connection)
        .with(response['data']['id'], 1)
        .and_return(true)

      post :create, params: { customer_id: customer.id, connection: params }, body: params

      expect(subject).to redirect_to 'http://test.host/customers/1/connections'
    end
  end
end

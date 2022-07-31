require 'rails_helper'
RSpec.describe CustomersController, type: :controller do
  describe '#new' do
    it 'create instant Customer' do
      subject.new

      expect(assigns[:customer]).to be
    end
  end

  describe '#create' do
    let!(:customer) do
      Customer.new(
        identifier: '1',
        secret: 'secret',
        user_id: 1
      )
    end
    let!(:params) do
      { 'customer' => { 'identifier' => '1' } }
    end

    it "create new Customer if doesn't exist" do
      params = { 'customer' => { 'identifier' => '1' } }

      response = {
        'data' => {
          'identifier' => '1',
          'secret' => 'secret'
        }
      }

      expect(ApiHelper)
        .to receive(:create_customer)
        .with(params['customer']['identifier'])
        .and_return(response)

      expect(CustomersHelper)
        .to receive(:create_customer_api_response)
        .with(response, 1)
        .and_return(customer)

      post :create, params: identifier
    end

    it 'could not create a customer that exists in db' do
      params = { 'customer' => { 'identifier' => '1' } }

      expect(CustomersHelper)
        .to receive(:customer_not_exists_in_db)
        .with(params['customer']['identifier'])
        .and_return(false)

      post :create, params: params

      expect(subject).to redirect_to 'http://test.host/customers/new'
    end

    it 'could not create a customer that do not exists in Db but is in api resonse' do
      data = {
        'error' => {
          'message' => "Customer with identifier '1' already exists"
        }
      }

      expect(ApiHelper)
        .to receive(:create_customer)
        .with(params['customer']['identifier'])
        .and_return(data)

      post :create, params: params

      expect(subject.request.flash['alert']).to eq(data['error']['message'])
    end
  end
end

require 'rails_helper'
RSpec.describe ApiHelper do
  it 'get the api response to create a customer' do
    identifier = '123'

    expect(Net::HTTP).to receive(:start).and_return({ identifier: identifier }.to_json)
    expect(described_class.create_customer(identifier)).to eq({ identifier: identifier }.to_json)
  end
end

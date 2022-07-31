require 'rails_helper'
RSpec.describe ApiHelper do
  it 'sosati' do
    identifier = '123'

    expect(Net::HTTP).to receive(:start).and_return({ asd: 'asd' }.to_json)
    expect(described_class.create_customer(identifier)).to eq({ asd: 'asd' }.to_json)
  end
end

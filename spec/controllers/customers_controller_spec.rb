require "rails_helper"
RSpec.describe CustomersController, type: :controller do

    describe "#new" do
        it "create instant Customer" do
            subject.new

            expect(assigns[:customer]).to be
        end
    end

    describe "#create" do
        it "create new Customer if doesn't exist" do
            identifier = {"identifier"=>"1"}

            expect(ApiHelper)
                .to receive(:create_customer)
                .with(identifier)
                .and_return({
                    "data" => {
                        "identifier" => identifier,
                        "secret"     => "secret"
                    }
                })

            post :create, params: {"customer" => identifier}

            customer = Customer.first

            expect(customer.identifier).to eq(identifier)
            expect(customer.secret).to eq("secret")
        end
    end
end
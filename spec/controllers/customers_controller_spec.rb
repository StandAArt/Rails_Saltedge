require "rails_helper"
RSpec.describe CustomersController, type: :controller do
    describe "#new" do
        it "create instant Customer" do
            subject.new

            expect(assigns[:customer]).to be
        end
    end

    describe "#create" do
        let(:customer) {
            @customer = Customer.new(
                identifier: "1",
                secret: "secret",
                user_id: 1) 
        }

        it "create new Customer if doesn't exist" do
            identifier = "1"

            response = {
                "data" => {
                    "identifier" => identifier,
                    "secret"     => "secret"
                }
            }

            allow(ApiHelper)
                .to receive(:create_customer)
                .with(identifier)
                .and_return(response)
            
            allow(CustomersHelper)
                .to receive(:create_customer_api_response)
                .with(response, 1)
                .and_return(customer)

            expect(customer.identifier).to eq(identifier)
            expect(customer.secret).to eq("secret")
        end
    end

    describe "#create" do
        it "could not create a customer that exists in db" do
            identifier = {"identifier"=>"1"}

            allow(CustomersHelper)
                 .to receive(:customer_not_exists_in_db)
                 .with(identifier["identifier"])
                 .and_return(false)
        end
    end

    describe "#create" do
        it "could not create a customer that do not exists in Db but is in api resonse" do
            data = {
                "error"=> {
                    "message" => "Customer with identifier '1' already exists"
                }
            }

            allow(ApiHelper)
              .to receive(:create_customer)
              .with("1")
              .and_return(data)

            expect(ApiHelper.create_customer("1")).to eq(data)
        end
    end
end
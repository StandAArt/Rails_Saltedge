class AccountsController < ApplicationController
    def index
        @customer = Customer.find(params[:customer_id])
        @connection = Connection.find(params[:connection_id])
    end
end

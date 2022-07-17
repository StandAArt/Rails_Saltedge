class ConnectionsController < ApplicationController
    def index
        @customer = Customer.find(params[:customer_id])
    end

    def new 
        @customer = Customer.find(params[:customer_id])
        @connection = Connection.new(customer_id: @customer.id)
    end

    def create
        @customer = Customer.find(connection_params[:customer_id])
        response = ApiHelper.create_connection(@customer.identifier, connection_params[:country_code], connection_params[:provider_code])

        if response["error"].present?
            redirect_to new_customer_connection_path, alert: response["error"]["message"]
          else
      
          end
    end

    private
    def connection_params
      params.require(:connection).permit(:customer_id, :country_code, :provider_code)
    end
end

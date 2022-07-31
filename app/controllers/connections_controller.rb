class ConnectionsController < ApplicationController
  before_action :set_customer, only: [:index, :new]

    def index; end

    def new 
        @connection = Connection.new(customer_id: @customer.id)
    end

    def create
        connection = ConnectionsHelper.find_connection_in_db(connection_params)
 
        if connection.present?
          redirect_to new_customer_connection_path, alert: "Connection with Id = '#{connection.connection_string_id}' already exists"
          return
        end

        customer = Customer.find(connection_params[:customer_id])
        response = ApiHelper.create_connection(customer.customer_string_id, connection_params[:country_code], connection_params[:provider_code])

        if response["error"].present?
            redirect_to new_customer_connection_path, alert: response["error"]["message"]
          else
            ConnectionsHelper.create_connection_with_api_result_data(customer.id, response)
            AccountsHelper.create_update_accounts_for_connection(response["data"]["id"], 1)
            redirect_to customer_connections_path
          end
    end
    
    def update
      response = ApiHelper.refresh_or_reconnect_connection(params[:connection_string_id], params[:perform_action])

      if response["error"].present?
        redirect_to customer_connections_path, alert: response["error"]["message"]
      else
        ConnectionsHelper.update_connection_with_api_result_data(params[:id], response)
        AccountsHelper.create_update_accounts_for_connection(params[:connection_string_id], 4)
        redirect_to customer_connections_path
      end
    end

    def destroy
       response = ApiHelper.remove_connection(params[:connection_string_id])

      if response["error"].present?
        redirect_to customer_connections_path, alert: response["error"]["message"]
      else
        Connection.find(params[:id]).destroy
        redirect_to customer_connections_path
      end
    end

    private

    def connection_params
      params.require(:connection).permit(:customer_id, :country_code, :provider_code)
    end

    def set_customer
      @customer = Customer.find(params[:customer_id])
    end
end

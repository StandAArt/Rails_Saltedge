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
        response = ApiHelper.create_connection(@customer.customer_string_id, @customer.secret, connection_params[:country_code], connection_params[:provider_code])

        if response["error"].present?
            redirect_to new_customer_connection_path, alert: response["error"]["message"]
          else
             @connection = Connection.new(
                secret: response["data"]["secret"],
                provider_id: response["data"]["provider_id"],
                provider_code: response["data"]["provider_code"],
                provider_name: response["data"]["provider_name"],
                daily_refresh: response["data"]["daily_refresh"],
                last_success_at: response["data"]["last_success_at"],
                status: response["data"]["status"],
                country_code: response["data"]["country_code"],
                next_refresh_possible_at:  response["data"]["next_refresh_possible_at"],
                store_credentials: response["data"]["store_credentials"],
                show_consent_confirmation: response["data"]["show_consent_confirmation"],
                last_consent_id: response["data"]["last_consent_id"],
                customer_id: @customer.id,
                connection_string_id: response["data"]["id"]
             )

             @connection.save
             redirect_to customer_connections_path
          end
    end
    
    def update
      response = ApiHelper.refresh_or_reconnect_connection(params[:connection_string_id], params[:customer_secret], params[:connection_secret], params[:perform_action])

      if response["error"].present?
        redirect_to customer_connections_path, alert: response["error"]["message"]
      else
        update_connection_with_api_result_data(params[:id], response)
        redirect_to customer_connections_path
      end
    end

    def destroy
       response = ApiHelper.remove_connection(params[:connection_string_id], params[:customer_secret], params[:connection_secret])

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

    def update_connection_with_api_result_data(connectionId, response)
        Connection.find(connectionId).update(
          secret: response["data"]["secret"],
          provider_id: response["data"]["provider_id"],
          provider_code: response["data"]["provider_code"],
          provider_name: response["data"]["provider_name"],
          daily_refresh: response["data"]["daily_refresh"],
          last_success_at: response["data"]["last_success_at"],
          status: response["data"]["status"],
          country_code: response["data"]["country_code"],
          next_refresh_possible_at:  response["data"]["next_refresh_possible_at"],
          store_credentials: response["data"]["store_credentials"],
          show_consent_confirmation: response["data"]["show_consent_confirmation"],
          last_consent_id: response["data"]["last_consent_id"],
          connection_string_id: response["data"]["id"]
        )
    end
end

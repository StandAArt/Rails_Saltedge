module ConnectionsHelper
    def self.find_connection_in_db(connection_params)
        Connection.where(customer_id:  connection_params[:customer_id], country_code: connection_params[:country_code],
            provider_code: connection_params[:provider_code]).take
    end

    def self.create_connection_with_api_result_data(customerId, response)
        connection = Connection.create(
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
            customer_id: customerId,
            connection_string_id: response["data"]["id"]
        )

        connection.save        
    end


    def self.update_connection_with_api_result_data (connectionId, response)
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

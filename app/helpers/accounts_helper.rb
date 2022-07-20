module AccountsHelper

    def self.create_update_accounts_for_connection(connection_string_id, api_call_number, from_id = nil)
         response = ApiHelper.get_accounts_api_request(connection_string_id, from_id)
         
         if !response["data"].present? && api_call_number < Max_Api_Call_Number
            api_call_number += 1
            sleep(3)
            create_update_accounts_for_connection(connection_string_id, api_call_number)
         end

         connection = Connection.where(connection_string_id: connection_string_id).first_or_initialize

         if !response["error"].present? && connection.present?
            create_update_account_in_db(connection.id, response)
            
            Account.where(connection_id: connection.id).all.each do |account|
               TransactionsHelper.create_update_transactions_for_accounts(connection_string_id, account.account_string_id, account.id, 4)
            end
         end

         if response["meta"]["next_page"].present?
            create_update_accounts_for_connection(connection_string_id, api_call_number, response["meta"]["next_id"])
            return
         end

         return response
    end

    def self.create_update_account_in_db(connection_id, response)
      response["data"].each do |data|
         @account = Account.where(account_string_id: data["id"]).first_or_initialize
         
             if @account.present?
                @account.name                       = data["name"]
                @account.nature                     = data["nature"]
                @account.balance                    = data["balance"]
                @account.currency_code              = data["currency_code"]
                @account.cards                      = data["cards"]
                @account.posted_transactions_count  = data["posted_transactions_count"]
                @account.pending_transactions_count = data["pending_transactions_count"]
                @account.connection_id              = connection_id
                @account.account_string_id          = data["id"]
                
             else
               @account = Account.create(
                name:                       data["name"],
                nature:                     data["nature"],
                balance:                    data["balance"],
                currency_code:              data["currency_code"],
                cards:                      data["cards"],
                posted_transactions_count:  data["posted_transactions_count"],
                pending_transactions_count: data["pending_transactions_count"],
                connection_id:              connection_id,
                account_string_id:          data["id"]
                )
             end

             @account.save
          
         end
      end
end

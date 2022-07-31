module TransactionsHelper
  def self.create_update_transactions_for_accounts(connection_string_Id, account_string_id, account_id, api_call_number, from_id = nil)
    response = ApiHelper.get_transactions_api_request(connection_string_Id, account_string_id, from_id)

    if !response['data'].present? && api_call_number < Max_Api_Call_Number
      api_call_number += 1
      create_update_transactions_for_accounts(connection_string_Id, account_string_id, account_id,
                                              api_call_number)
      return
    end

    create_update_transaction_in_db(account_id, response) unless response['error'].present?

    if response['meta']['next_page'].present?
      create_update_transactions_for_accounts(connection_string_id, api_call_number, response['meta']['next_id'])
      nil
    end
  end

  def self.create_update_transaction_in_db(account_id, response)
    response['data'].each do |data|
      @transaction = Transaction.where(transaction_string_id: data['id']).first_or_initialize

      if @transaction.present?
        @transaction.mode = data['mode']
        @transaction.status                     = data['status']
        @transaction.made_on                    = data['made_on']
        @transaction.amount                     = data['amount']
        @transaction.currency_code              = data['currency_code']
        @transaction.description                = data['description']
        @transaction.category                   = data['category']
        @transaction.duplicated                 = data['duplicated']
        @transaction.merchant_id                = data['merchant_id']
        @transaction.original_amount            = data['original_amount']
        @transaction.original_currency_code     = data['original_currency_code']
        @transaction.posting_date               = data['posting_date']
        @transaction.time                       = data['time']
        @transaction.transaction_string_id      = data['id']
        @transaction.account_id                 = account_id
      else
        @account = Account.create(
          mode: data['mode'],
          status: data['status'],
          made_on: data['made_on'],
          amount: data['amount'],
          currency_code: data['currency_code'],
          description: data['description'],
          category: data['category'],
          duplicated: data['duplicated'],
          merchant_id: data['merchant_id'],
          original_amount: data['original_amount'],
          original_currency_code: data['original_currency_code'],
          posting_date: data['posting_date'],
          time: data['time'],
          transaction_string_id: data['id'],
          account_id:
        )
      end

      @transaction.save
    end
  end
end

module CustomersHelper
  def self.create_customer_api_response(response, user_id)
    @customer = Customer.new(
      identifier: response['data']['identifier'],
      secret: response['data']['secret'],
      user_id:,
      customer_string_id: response['data']['id']
    )

    @customer.save
  end

  def self.customer_not_exists_in_db(identifier)
    Customer.where(identifier:).blank?
  end
end

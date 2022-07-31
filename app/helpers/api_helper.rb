module ApiHelper
  SALTEDGE = "https://www.saltedge.com/api/v5".freeze
  
  def self.create_customer(identifier)
    uri = URI.parse("#{SALTEDGE}/customers")

      body = JSON.dump({
        "data" => {
          "identifier" => identifier
        }
      })

      generate_and_send_api_request("POST", uri, body)
  end 

  def self.create_connection(customer_id, country_code, provider_code)
    uri = URI.parse("#{SALTEDGE}/connections")
   
    body = JSON.generate({
      "data" => {
        "customer_id" => customer_id,
        "country_code" => country_code,
        "provider_code" => provider_code,
        "include_fake_providers" => true,
        "consent" => {
          "from_date" => Time.now.utc.strftime("%Y/%m/%d"),
          "scopes" => [
            "account_details",
            "transactions_details"
          ]
        },
        "credentials" => {
          "login" => "username123",
          "password" => "secret",
          "sms" => "123456"
        }
      }
    })

    generate_and_send_api_request("POST", uri, body)
  end
  
  def self.refresh_or_reconnect_connection(connection_id, perform_action)
    uri = perform_action == "refresh" ? URI.parse("#{SALTEDGE}/connection/refresh") : URI.parse("#{SALTEDGE}/connection/reconnect")

    body = JSON.generate({
      "data" => {
        "id" => connection_id,
        "credentials" => {
          "login" => "username",
          "password" => "secret"
        },
        "consent" => {
          "scopes" => [
            "account_details"
          ]
        },
        "override_credentials" => true
      }
    })
 
    generate_and_send_api_request("PUT", uri, body)
  end

  def self.remove_connection(connection_id)
    uri = URI.parse("#{SALTEDGE}/connection") 
   
    body = JSON.generate({
      "data" => {
        "id" => connection_id
      }
    })

    generate_and_send_api_request("DELETE", uri, body)
  end

  def self.get_accounts_api_request(connection_id, from_id=nil)
    path = "#{SALTEDGE}/accounts?connection_id=#{connection_id}"
    
    path += "&from_id=#{from_id}" if from_id.present?

    uri = URI.parse(path) 
    generate_and_send_api_request("GET", uri)
  end

  def self.get_transactions_api_request(connection_id, account_id, from_id = nil)
    path = "#{SALTEDGE}/transactions?connection_id=#{connection_id}&account_id=#{account_id}"

      path += "&from_id=#{from_id}" if from_id.present?
    
    uri = URI.parse(path) 
    generate_and_send_api_request("GET", uri)
  end

  def self.get_next_page_set_of_entity_api(path)
    uri = URI.parse(path)
    generate_and_send_api_request("GET", uri) 
  end

private
  def self.generate_and_send_api_request(methodType, uri, body = nil)
   

    case methodType
    when "POST"
      request = Net::HTTP::Post.new(uri)
    when "PUT"
      request = Net::HTTP::Put.new(uri)
    when "DELETE"
      request = Net::HTTP::Delete.new(uri)
    else
      request = Net::HTTP::Get.new(uri)
    end

    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["App-Id"] = App_Id
    request["Secret"] = Secret

    request.body = body if body != nil
    
    req_options = {
      use_ssl: uri.scheme == "https",
    }

     Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
       response = http.request(request)
       JSON.parse(response.body)
     end
  end
end
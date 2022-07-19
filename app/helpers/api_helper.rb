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

  def self.create_connection(customer_id, customer_secret, country_code, provider_code)
    uri = URI.parse("#{SALTEDGE}/connections")
   
    body = JSON.generate({
      "data" => {
        "customer_id" => customer_id,
        "country_code" => country_code,
        "provider_code" => provider_code,
        "include_fake_providers" => true,
        "consent" => {
          "from_date" => Time.now.strftime("%Y/%m/%d"),
          "scopes" => [
            "account_details",
            "transactions_details"
          ]
        },
        "credentials" => {
          "login" => "username",
          "password" => "secret"
        }
      }
    })
    
    generate_and_send_api_request("POST", uri, body, customer_secret)
  end
  
  def self.refresh_or_reconnect_connection(connection_id, customer_secret, connection_secret, perform_action)
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
 
    generate_and_send_api_request("PUT", uri, body, customer_secret, connection_secret)
  end

  def self.remove_connection(connection_id, customer_secret, connection_secret)
    uri = URI.parse("#{SALTEDGE}/connection") 
   
    body = JSON.generate({
      "data" => {
        "id" => connection_id
      }
    })

    generate_and_send_api_request("DELETE", uri, body, customer_secret, connection_secret)
  end

  def self.get_accounts()

  end

private
  def self.generate_and_send_api_request(methodType, uri, body, customer_secret = nil, connection_secret = nil)
    request = Net::HTTP::Get.new(uri)

    case methodType
    when "POST"
      request = Net::HTTP::Post.new(uri)
    when "PUT"
      request = Net::HTTP::Put.new(uri)
    when "DELETE"
      request = Net::HTTP::Delete.new(uri)
    end

    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["App-Id"] = App_Id
    request["Secret"] = Secret

    if(customer_secret != nil)
      request["Customer-secret"] = customer_secret
    end

    if(connection_secret != nil)
      request["Connection-secret"] = connection_secret
    end

    request.body = body
    req_options = {
      use_ssl: uri.scheme == "https",
    }

     Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
     response = http.request(request)
     JSON.parse(response.body)
     end
  end
end
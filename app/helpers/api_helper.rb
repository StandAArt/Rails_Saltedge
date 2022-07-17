module ApiHelper
  SALTEDGE = "https://www.saltedge.com/api/v5".freeze
  
  def self.create_customer(identifier)
    uri = URI.parse("#{SALTEDGE}/customers")

    request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["Accept"] = "application/json"
      request["App-Id"] = App_Id
      request["Secret"] = Secret
      request.body = JSON.dump({
        "data" => {
          "identifier" => identifier
        }
      })

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      Net::HTTP.start(uri.host, uri.port, req_options) do |http|
        response = http.request(request)
        JSON.parse(response.body)
      end
  end 

  def self.create_connection(customer_id, country_code, provider_code)
    uri = URI.parse("#{SALTEDGE}/connections")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["App-Id"] = App_Id
    request["Secret"] = Secret
    request["Customer-secret"] = "fake_client_secret"
    request.body = JSON.dump({
      "data" => {
        "customer_id" => customer_id,
        "country_code" => country_code,
        "provider_code" => provider_code,
        "consent" => {
          "from_date" => "2020-06-07",
          "scopes" => [
            "account_details",
            "transactions_details"
          ]
        },
        "attempt" => {
          "from_date" => "2020-07-07",
          "fetch_scopes" => [
            "accounts",
            "transactions"
          ],
          "custom_fields" => {
            "test" => true
          }
        },
        "credentials" => {
          "login" => "fake_client_id",
          "password" => "fake_client_secret"
        }
      }
    })
    
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    
    Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    response = http.request(request)
    JSON.parse(response.body)
    end
  end
  
end
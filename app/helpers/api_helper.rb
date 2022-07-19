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

  def self.create_connection(customer_id, customer_secret, country_code, provider_code)
    uri = URI.parse("#{SALTEDGE}/connections")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["App-Id"] = App_Id
    request["Secret"] = Secret
    request["Customer-secret"] = customer_secret
    request.body = JSON.generate({
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
    
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    
    Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    response = http.request(request)
    JSON.parse(response.body)
    end
  end
  
  def self.refresh_or_reconnect_connection(connection_id, customer_secret, connection_secret, perform_action)
    uri = perform_action == "refresh" ? URI.parse("#{SALTEDGE}/connection/refresh") : URI.parse("#{SALTEDGE}/connection/reconnect")
    request = Net::HTTP::Put.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["App-Id"] = App_Id
    request["Secret"] = Secret
    request["Customer-secret"] = customer_secret
    request["Connection-secret"] = connection_secret
    request.body = JSON.generate({
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
    req_options = {
      use_ssl: uri.scheme == "https",
    }

    Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      response = http.request(request)
      JSON.parse(response.body)
    end
  end

  def self.remove_connection(connection_id, customer_secret, connection_secret)
    uri = URI.parse("#{SALTEDGE}/connection") 
    request = Net::HTTP::Delete.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["App-Id"] = App_Id
    request["Secret"] = Secret
    request["Customer-secret"] = customer_secret
    request["Connection-secret"] = connection_secret
    request.body = JSON.generate({
      "data" => {
        "id" => connection_id
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
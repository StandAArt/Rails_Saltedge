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

  def self.create_connection
    binding.pry
  end
end
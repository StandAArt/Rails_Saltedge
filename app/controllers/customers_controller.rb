class CustomersController < ApplicationController
    require 'net/http'
    require 'uri'
    require 'json'

    def new 
        @customer = Customer.new
     end
 
     def create 
       @user = current_user      

      if Customer.where(:identifier => customer_params["identifier"]).blank?
        response = create_customer_api
     
        if response["error"] != nil
          redirect_to new_customer_path, alert: response["error"]["message"]
        else
          @customer = Customer.new(
            identifier: response["data"]["identifier"],
            secret: response["data"]["secret"],
            user_id: @user.id
          )

          @test = @customer

          @customer.save
          redirect_to root_path
        end
       
      else
        redirect_to new_customer_path, alert: "The customer you are trying to create already exists"
      end


     end

     private
     def create_customer_api
      identifier = customer_params["identifier"]

      uri = URI.parse("https://www.saltedge.com/api/v5/customers")
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
       error = nil

        return JSON.parse(response.body)
       end
    end
    
  private
  def customer_params
    params.require(:customer).permit(:identifier)
  end

end

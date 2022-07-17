class CustomersController < ApplicationController

    def new 
        @customer = Customer.new
     end
 
     def create 
       @user = current_user      

      if Customer.where(:identifier => customer_params["identifier"]).blank?
        response = ApiHelper.create_customer(customer_params["identifier"])
     
        if response["error"].present?
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
  def customer_params
    params.require(:customer).permit(:identifier)
  end

end

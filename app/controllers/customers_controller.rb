class CustomersController < ApplicationController
    def new 
        @customer = Customer.new
     end
 
     def create 
       @user = current_user      

      if CustomersHelper.customer_not_exists_in_db(customer_params["identifier"])
        response = ApiHelper.create_customer(customer_params["identifier"])
     
        if response["error"].present?
          redirect_to new_customer_path, alert: response["error"]["message"]
        else
          CustomersHelper.create_customer_api_response(response, @user.id)
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

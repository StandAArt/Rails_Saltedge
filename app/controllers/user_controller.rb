class UserController < ApplicationController
    before_action :authenticate_user!

    def show
        @user = current_user
        @user.customers = Customer.where(user_id: @user.id)
    end
end

class AccountsController < ApplicationController
    def index
        @connection = Connection.find(params[:connection_id])
    end
end

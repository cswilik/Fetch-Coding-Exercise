class TransactionsController < ApplicationController

    def index 
        @transactions = Transaction.all
        render json: @transactions
    end

    def new
        @transaction = Transaction.new
    end

    def create
        @transaction.create(transaction_params)
    end

    private
    def transaction_params
        params.require(:transaction).permit(:payer, :points, :date)
    end
end

class TransactionsController < ApplicationController

    def index 
        @transactions = Transaction.all
        render json: @transactions
    end


    def create
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
            render json: @transaction
        else
            render json: @transaction.errors.full_messages
        end
    end

    def spend
        # first we need to order the transactions by date.
        ordered = Transaction.all.order(:date)
        # our points are the input we entered.
        points = params[:points].to_i
        # array to hold our points spent response
        spent = {}
        # loop through our ordered list
        i= 0
        while i < ordered.length do
            if points == 0
                break
            end 
            @transaction = Transaction.find_by id: ordered[i].id
            # if you have more points than in the transaction - update transaction points to 0
                # and update points minus the points we've used
                # add obj to spent**
            # else - update transaction with trans.points - points
                # points is now 0
                # push obj of call into spent**
            if points >= @transaction.points
                points = points - @transaction.points
                @transaction.update(@transaction, :points => 0)
            else 
                remaining = @transaction.points - points
                points = 0
                @transaction.update(@transaction, :points => remaining)
            end
            i+= 1
        end
        byebug
        render json: spent
    end

    private
    def transaction_params
        params.require(:transaction).permit(:payer, :points, :date)
    end
end

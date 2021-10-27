class TransactionsController < ApplicationController

    def index 
        @transactions = Transaction.all.order(:date)
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
                # byebug
                # if you have more points than in the transaction:
                    # and update points minus the points we've used
                    # update transaction points to 0
                    # add obj to spent**
                # else - update transaction with trans.points - points
                    # points is now 0
                    # push obj of call into spent**
            if @transaction.points >= 0
                if points > @transaction.points
                    points = points - @transaction.points
                    spent[@transaction.payer] = -1 * @transaction.points
                    @transaction.update(:points => 0)
                else 
                    remaining = @transaction.points - points
                    spent[@transaction.payer] = -1 * points
                    points = 0
                    @transaction.update(:points => remaining)
                end
            else 
                # add the -points to points
                points = points - @transaction.points
                # update spent by subtracting (adding) neg points
                spent[@transaction.payer] = spent[@transaction.payer] -= @transaction.points
                @transaction.update(:points => 0)
            end
            i+= 1
        end
        render json: spent
    end

    private
    def transaction_params
        params.require(:transaction).permit(:payer, :points, :date)
    end
end

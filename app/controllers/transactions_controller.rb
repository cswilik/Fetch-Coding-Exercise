class TransactionsController < ApplicationController

    def index 
        # I just made the root ordered as well so I could test my code
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


    # one 'edge case' I thought about would be what if you try to spend more points than you have?
    # we would need a helper method to sum all points
    # check if points > total-points
        # if yes, thow error message like "not enough points!"
    def spend
        # first we need to order the transactions by date.
        ordered = Transaction.all.order(:date)
        # our points are the input we entered.
        points = params[:points].to_i
        # obj to hold our points spent response
        spent = {}
        # loop through our ordered list
        i= 0
        while i < ordered.length do
            if points == 0
                break
            end 
            @transaction = Transaction.find_by id: ordered[i].id
            if @transaction.points >= 0
                if points > @transaction.points
                # if you have more points than in the transaction:
                    # update points minus the points we've used
                    # add key + value to our 'spent' obj
                    # update transaction points to 0
                    points = points - @transaction.points
                    spent[@transaction.payer] = -1 * @transaction.points
                    @transaction.update(:points => 0)
                else 
                # else 
                    #  update transaction with remaining pts
                    # add/update spent obj
                    # points is now 0
                    remaining = @transaction.points - points
                    spent[@transaction.payer] = -1 * points
                    points = 0
                    @transaction.update(:points => remaining)
                end
            else 
                # add the -points to points (were increasing our points here)
                points = points - @transaction.points
                # update spent by subtracting (adding) neg points
                spent[@transaction.payer] = spent[@transaction.payer] -= @transaction.points
                @transaction.update(:points => 0)
            end
            i+= 1
        end
        render json: spent
    end

    def balance
        bal = {}
        #find sum for each payers points in each transaction
        Transaction.all.each do |t|
            if bal[t.payer] 
                bal[t.payer] += t.points
            else
                bal[t.payer] = t.points
            end
        end 
         render json: bal
    end

    private
    def transaction_params
        params.require(:transaction).permit(:payer, :points, :date)
    end
end

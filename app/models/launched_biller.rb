module LaunchedBiller

    def usage(params)
        10
    end

    def paid(params)
        #  Api::Balances.new.show(params).balances
        12
    end

    def transacted(params)
        Api::Billingtransactions.new.list(params).transactions
    end


    def bill(params)
        {
            usage: usage(params),
            paid: paid(params),
            transactions: transacted(params)
        }
    end
end

module LaunchedBiller

    def usage
        90
    end

    def paid
        100
    end


    def bill
        {
            usage: usage,
            paid: paid
        }
    end
end

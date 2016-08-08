class Biller::Result
    attr_accessor :order_id, :fraud_check, :redirect

    attr_accessor :failed, :failed_reason

    def initialize
        @failed = false
    end

    def failed?
        !!@failed
    end

    def to_client_hash
        {fraud_checked: true}
    end
end

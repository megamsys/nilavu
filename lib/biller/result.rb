class Biller::Result
    attr_accessor :order_id, :fraud_check, :redirect

    attr_accessor :failed, :failed_reason

    attr_accessor :result, :message, :clientid, :error

    attr_accessor :userid, :id, :firstname, :lastname, :fullname, :companyname, :email, :address1, :address2, :city, :fullstate, :state, :postcode, :countrycode, :country, :phonenumber, :password, :statecode, :countryname, :phonecc, :phonenumberformatted, :billingcid, :notes, :twofaenabled, :currency, :defaultgateway, :cctype, :cclastfour, :securityqid, :securityqans, :groupid, :status, :credit, :taxexempt, :latefeeoveride, :overideduenotices, :separateinvoices, :disableautocc, :emailoptout, :overrideautoclose, :language, :lastlogin, :currency_code

    def initialize
        @failed = false
    end

    def failed?
        !!@failed
    end

    def to_client_hash
        {fraud_checked: true}
    end

    def to_hash
      {
        :id => @id,
        :email => @email,
        :result => @result,
        :message => @message,
      }
    end

end

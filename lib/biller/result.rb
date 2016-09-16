class Biller::Result
    attr_accessor :order_id, :fraud_checked, :redirect

    attr_accessor :failed, :failed_reason

    attr_accessor :result, :message, :clientid, :error, :action

    attr_accessor :userid, :id, :firstname, :lastname, :fullname, :companyname, :email, :address1, :address2, :city, :fullstate, :state, :postcode, :countrycode, :country, :phonenumber, :password, :statecode, :countryname, :phonecc, :phonenumberformatted, :billingcid, :notes, :twofaenabled, :currency, :defaultgateway, :cctype, :cclastfour, :securityqid, :securityqans, :groupid, :status, :credit, :taxexempt, :latefeeoveride, :overideduenotices, :separateinvoices, :disableautocc, :emailoptout, :overrideautoclose, :language, :lastlogin, :currency_code, :customfields1, :customfields, :customfields2, :customfields3, :action, :username, :accesskey

    attr_accessor :products, :version, :totalresults, :provider, :createdAt, :billingcycle, :controller, :api_key, :org_id, :username, :accesskey, :orderid, :productids, :addonids, :domainids, :invoiceid, :pid, :paymentmethod, :attributes

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
        :action => @action,
        :result => @result,
        :message => @message,
        :clientid => @clientid
      }
    end

end

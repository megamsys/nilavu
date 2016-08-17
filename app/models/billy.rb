class Billy

    attr_accessor :client_id
    attr_accessor :email
    attr_accessor :provider
    attr_accessor :created_at

    attr_accessor :json_claz
    attr_accessor :id
    attr_accessor :provider_id
    attr_accessor :account_id
    attr_accessor :provider_name
    attr_accessor :options

    def self.new_from_params(params)
        user = Billy.new
        params.symbolize_keys!
        params.each { |k, v| user.send("#{k}=", v) }
        user
    end

    def find_by_email(params)
        addon = Api::Addons.new.show(params.merge!(parms_using_provider)).addon
        if addon
            return Billy.new_from_params(addon.to_hash)
        end
    end

    def has_external_id?
        @provider_id.present?
    end

    def to_hash
        {   :email => @account_id,
            :clientid => @provider_id,
            :provider => @provider_name,
            :createdAt =>@created_at
        }
    end


    private

    def parms_using_provider
        {:provider => @provider }
    end
end

class Billy

    attr_accessor :client_id
    attr_accessor :email
    attr_accessor :provider
    attr_accessor :created_at

    def self.new_from_params(params)
        user = Billy.new
        params.symbolize_keys!
        params.each { |k, v| user.send("#{k}=", v) }
        user
    end

    def find_by_email(params)
        addon = Api::Addons.new.where(params.merge!(parms_using_provider))
        if addon
            return Billy.new_from_params(addon.to_hash)
        end
    end

    def has_external_id?
        @client_id.present?
    end


    def to_hash
        {   :email => @email,
            :client_id => @client_id,
            :provider => @provider,
            :createdAt =>@created_at
        }
    end


    private

    def parms_using_provider
        {:provider => @provider }
    end
end

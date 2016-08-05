require 'uri'

module WHMCSAutoAuth
    def self.redirect_url(email, action)
        ensure_autoauth_params

        time = Time.now.to_i

        query= ["email=#{email}","timestamp=#{time}",
                "hash="+ autoauth_hash(email, time),
                "goto="+ URI.encode("clientarea.php?action=#{action}")].join('&')

        return [SiteSetting.whmcs_autoauth_url, query].join("?")
    end

    private

    def self.ensure_autoauth_params
        raise Nilavu::NotFound unless SiteSetting.whmcs_autoauth_url && SiteSetting.whmcs_autoauth_key
    end

    def self.autoauth_hash(email, time)
        Digest::SHA1([email, time,SiteSetting.whmcs_autoauth_key].join(''))
    end

end

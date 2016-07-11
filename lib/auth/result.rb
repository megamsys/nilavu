class Auth::Result
    attr_accessor :user, :origin, :first_name, :email, :token,
    :email_valid, :extra_data, :awaiting_activation,
    :awaiting_approval, :authenticated, :authenticator_name,
    :requires_invite, :redirect

    attr_accessor :failed,
    :failed_reason

    def initialize
        @failed = false
    end

    def failed?
        !!@failed
    end

    def session_data
        { email: email,
            token: token,
            first_name: first_name,
            email_valid: email_valid,
            origin: origin,
            authenticator_name: authenticator_name,
        extra_data: extra_data }
    end

    def to_client_hash
        if requires_invite
            { requires_invite: true }
        elsif user
            if user.suspended?
                {
                    suspended: true,
                    suspended_message: I18n.t( user.suspend_reason ? "login.suspended_with_reason" : "login.suspended",
                    {date: I18n.l(user.suspended_till, format: :date_only), reason: user.suspend_reason} )
                }
            end
        else
            result = {
                auth_provider: authenticator_name.capitalize,
                authenticated: !!authenticated,
                awaiting_activation: !!awaiting_activation,
                awaiting_approval: !!awaiting_approval
            }.merge(session_data)
            result
        end
    end
end

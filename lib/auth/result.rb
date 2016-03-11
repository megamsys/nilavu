class Auth::Result
  attr_accessor :origin, :first_name, :email, :token,
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
    else
      result = { email: email,
        first_name: User.suggest_firstname(first_name || email),
        auth_provider: authenticator_name.capitalize,
        email_valid: !!email_valid,
        origin: origin,
      redirect: redirect}

      result
    end
  end
end

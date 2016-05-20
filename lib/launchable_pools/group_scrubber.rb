class GroupScrubber

  def initialize(user, session, scrubber_finder = OmniauthCallbacksController)
    @user = user
    @session = session[:authentication]
    @scrubber_finder = scrubber_finder
  end

  def start
    if authenticated?
      @user.active = true
    else
      @user.password_required!
    end
  end

  def has_scrubber?
    !!scrubber
  end

  def finish
    scrubber.after_create_account(@user, @session) if scrubber
    @session = nil
  end

  private

  def authenticated?
    @session && @session[:email] == @user.email && @session[:email_valid]
  end

  def scrubber
    if scrubber_name
      @scrubber ||= @scrubber_finder.find_scrubber(scrubber_name)
    end
  end

  def scrubber_name
    @session && @session[:scrubber_name]
  end

  private

  def self.find_scrubber(name)
    BUILTIN_AUTH.each do |scrubber|
      if scrubber.name == name
        raise Nilavu::InvalidAccess.new("provider is not enabled") unless SiteSetting.send("enable_#{name}_logins?")
        return scrubber
      end
    end

    Nilavu.auth_providers.each do |provider|
      return provider.scrubber if provider.name == name
    end

    raise Nilavu::InvalidAccess.new("provider is not found")
  end

end

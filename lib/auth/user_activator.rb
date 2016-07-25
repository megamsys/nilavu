class UserActivator
  attr_reader :user, :request, :session, :cookies, :message

  def initialize(user, request, session, cookies)
    @user = user
    @session = session
    @cookies = cookies
    @request = request
    @message = nil
  end

  def start
  end

  def finish
    @message = activator.activate
  end

  private

  def activator
    factory.new(user, request, session, cookies)
  end

  def factory
    LoginActivator
  end

end


class LoginActivator < UserActivator
  include CurrentUser

  def activate
    log_on_user(user)
    #schedule.defer
    #I18n.t("login.active")
  end
end

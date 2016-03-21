class CephUserActivator
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
    CephLoginActivator
  end

end

class CephLoginActivator < CephUserActivator
  include CurrentCephUser

  def activate
    log_on_cephuser(user)
    #schedule.defer
    #I18n.t("login.active")
  end
end

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
    #if  SiteSetting.OTP.present?
    #  MobileActivator
    #else
    LoginActivator
    #end
  end

end


class MobileActivator < UserActivator
  def activate
    email_token = user.email_tokens.unconfirmed.active.first
    #email_token = user.email_tokens.create(email: user.email) if email_token.nil?
    #Nilavu::OTP::Infobip.new.send_confirm("#{params['phone']}", "#{params['email']}") if SiteSetting.allow_otp_verifications
    #I18n.t("login.activate_email", email: user.email)
  end
end

class LoginActivator < UserActivator
  include CurrentCephUser

  def activate
    log_on_cephuser(user)
    #schedule.defer
    #I18n.t("login.active")
  end
end

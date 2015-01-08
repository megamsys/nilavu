class UserMailer < ActionMailer::Base
  default from: "support@megam.co.in"
  def welcome_email(user)
    logger.debug "user = #{user}"
    @user = user
    #@random_token = user.verification_hash
    #@url  = "https://www.megam.co/verified_email.#{@random_token}"
    mail(:to => user["email"], :subject => "Megam Account Confirmation")
  end

  def password_reset(user)
    @user = user
    mail :to => user["email"], :subject => "Reset your Megam Password"
  end

  def contact_email(user)
    logger.debug "user = #{user[:inputName]}"
    @contact_user = user
    mail(:to => "support@megam.co.in", :subject => "User contact information")
  end
  
  def error_email(error)
    logger.debug "error #{error[:email]} = #{error[:message]}"
    @error = error
    mail(:from => error[:email], :to => "support@megam.co.in", :subject => "#{@error[:email]} :www.megam.co, got #{@error[:message]}")
  end

end

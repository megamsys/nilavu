class UserMailer < ActionMailer::Base
  default from: "alrin@megam.co.in"

  def welcome_email(user)
	logger.debug "user = #{user}"
    @mailer_user = user
    @random_token = user.verification_hash
    @url  = "http://localhost:3000/verified_email"
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end

end

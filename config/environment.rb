# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Cloudauth::Application.initialize!

#config.action_mailer.delivery_method = :smtp
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
#ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address        => "smtp.googlemail.com",
  :port           => "587",
  :domain         => "megam.co.in",
  :user_name      => "alrin@megam.co.in",
  :password       => "team4megam",
  :authentication => :plain
}
ActionMailer::Base.default_url_options[:host] = "localhost:3000"

#script/generate mailer UserMailer

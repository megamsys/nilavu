# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Cloudauth::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address        => "smtp.googlemail.com",
  :port           => "587",
  :domain         => "megam.co.in",
  :user_name      => ENV['SUPPORT_EMAIL'],
  :password       => ENV['SUPPORT_PASSWORD'],
  :authentication => :plain
}

ActionMailer::Base.default_url_options[:host] = "https://www.megam.co"
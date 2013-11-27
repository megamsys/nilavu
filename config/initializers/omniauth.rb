Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '656642044368521', '0fb6a80893cdb88fdc2b2c021b454977'
  provider :twitter, 'RXzRHtYF4cYiVKhD0kmBg', 'hLPGq2f7Z6BoXN8I5USYYvGQyZtMMbl8FIhG49VY8Os'
  provider :google_oauth2, '1086028648606.apps.googleusercontent.com', '2rUaVHUCbu9CZClosVMJsrEv',
  {      
      :scope => "userinfo.email, userinfo.profile, https://www.googleapis.com/auth/compute, https://www.googleapis.com/auth/compute.readonly, https://www.googleapis.com/auth/devstorage.full_control, https://www.googleapis.com/auth/devstorage.read_only, https://www.googleapis.com/auth/devstorage.read_write, https://www.googleapis.com/auth/devstorage.write_only, https://www.googleapis.com/auth/userinfo.email",
      :prompt => 'consent'
    }
#  provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end

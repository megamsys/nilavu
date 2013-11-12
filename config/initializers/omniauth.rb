Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '656642044368521', '0fb6a80893cdb88fdc2b2c021b454977'
  provider :twitter, 'RXzRHtYF4cYiVKhD0kmBg', 'hLPGq2f7Z6BoXN8I5USYYvGQyZtMMbl8FIhG49VY8Os'
#  provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end

Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :facebook, '186097558172017', '"c2bb25e60640ebabcee20c7079214174'
  provider :facebook, '259070960835536', 'd290dcfe9e042ce2734d6a55f8d6235b'
#  provider :twitter,  'AbrsTN4LG45yhpwPi07JjA', 'GCOmMkgnoedVjmyAteGSBsFNUgMV7Saet14uujig' 
  provider :twitter, 'RXzRHtYF4cYiVKhD0kmBg', 'hLPGq2f7Z6BoXN8I5USYYvGQyZtMMbl8FIhG49VY8Os'

#  provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end

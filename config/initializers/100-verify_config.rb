# Check that the app is configured correctly. Raise some helpful errors if something is wrong.

#if defined?(Rails::Server) and Rails.env.production? # Only run these checks when starting up a production server

#  if ['localhost', 'production.localhost'].include?(Nilavu.current_hostname)
#    puts <<END

#      api_server  = '#{Nilavu.current_api_server}'

#      Please update the api_server property in nilavu.yml so that it can
#      be reached and is pingable. Otherwise you can't run nilavu reliably.

#END

#    raise "Invalid API server in nilavu.yml"
#  end

#end

module Auth; end


require_dependency 'current_user'
require_dependency 'current_cephuser'
require_dependency 'auth/result'
require_dependency 'auth/authenticator'
require_dependency 'auth/facebook_authenticator'
require_dependency 'auth/github_authenticator'
require_dependency 'auth/google_oauth2_authenticator'

require_dependency 'auth/current_user_provider'
require_dependency 'auth/default_current_user_provider'
require_dependency 'auth/user_authenticator'
require_dependency 'auth/user_activator'
require_dependency 'auth/current_cephuser_provider'
require_dependency 'auth/default_cephuser_provider'
require_dependency 'auth/cephuser_activator'
require_dependency 'auth/emailchecker_service'

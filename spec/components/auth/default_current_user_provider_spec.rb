require 'rails_helper'
require_dependency 'auth/default_current_user_provider'

describe Auth::DefaultCurrentUserProvider do

    def provider(url, opts=nil)
        opts ||= {method: "GET"}
        env = Rack::MockRequest.env_for(url, opts)
        Auth::DefaultCurrentUserProvider.new(env)
    end

end

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Setup in-memory test server for Riak


require 'ripple/test_server'



class ActiveSupport::TestCase


  setup { Ripple::TestServer.setup }


  teardown { Ripple::TestServer.clear }

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

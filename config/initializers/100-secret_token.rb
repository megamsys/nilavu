# We have had lots of config issues with SECRET_TOKEN to avoid this mess we are moving it to redis
#  if you feel strongly that it does not belong there use ENV['SECRET_TOKEN']
#
token = ENV['NIL_SECRET_TOKEN']
unless token
  unless token && token.length == 128
    token = SecureRandom.hex(64)
  end
end

Nilavu::Application.config.secret_key_base = token
Nilavu::Application.config.secret_token =token

# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Nilavu::Application.config.secret_key_base = '1a3f4cc1f99889624598e167af92fe4c907e6f93987113b07ecc0526b98ed05b302f0022acf905da1d5eda3c5d1707019f886e1a96d59de2538ac431fd5ea9e6'

Nilavu::Application.config.secret_token = '70643cf78a3856fad9db794dc3ad0876f5de811a1c2a0dc9a437b9924835c761511a50250b0eb275474e36f83b020d7cb1ac3c9443d8d5b1812d506d9f7a1d1d'

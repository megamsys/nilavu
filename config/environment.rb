# Load the rails application
require File.expand_path('../application', __FILE__)
# Initialize the rails application
Nilavu::Application.initialize!

CarrierWave.configure do |config|
  config.fog_attributes = { :multipart_chunk_size => 104857600 }
end

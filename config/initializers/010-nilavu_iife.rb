require 'nilavu_iife'

Rails.application.assets.register_preprocessor('application/javascript', NilavuIIFE)
unless Rails.env.production? || ENV["DISABLE_EVAL"]
  require 'source_url'
  Rails.application.assets.register_postprocessor('application/javascript', SourceURL)
end

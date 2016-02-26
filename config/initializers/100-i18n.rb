# order: after 02-freedom_patches.rb

require 'i18n/backend/nilavu_i18n'
I18n.backend = I18n::Backend::NilavuI18n.new
I18n.config.missing_interpolation_argument_handler = proc { throw(:exception) }
I18n.init_accelerator!

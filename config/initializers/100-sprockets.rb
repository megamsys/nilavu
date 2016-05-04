require_dependency 'sass/nilavu_stylesheets'
require_dependency 'sass/nilavu_sass_importer'
require_dependency 'sass/nilavu_safe_sass_importer'

NilavuSassTemplate = Class.new(Sass::Rails::SassTemplate) do
  def importer_class
    NilavuSassImporter
  end
end
NilavuScssTemplate = Class.new(NilavuSassTemplate) do
  def syntax
    :scss
  end
end

Rails.application.config.assets.configure do |env|
  env.register_engine '.sass', NilavuSassTemplate
  env.register_engine '.scss', NilavuScssTemplate
end

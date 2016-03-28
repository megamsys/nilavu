require_dependency 'sass/nilavu_stylesheets'
require_dependency 'sass/nilavu_sass_importer'
require_dependency 'sass/nilavu_safe_sass_importer'

if defined?(Sass::Rails::SassTemplate)
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
  Rails.application.assets.register_engine '.sass', NilavuSassTemplate
  Rails.application.assets.register_engine '.scss', NilavuScssTemplate
#TO-DO
  Rails.application.assets.register_engine '.css', NilavuScssTemplate
else
  Sprockets.send(:remove_const, :SassImporter)
  Sprockets::SassImporter = NilavuSassImporter
end

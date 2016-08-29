
require 'sprockets'

#Sprockets.register_engine '.es6', Tilt::ES6ModuleTranspilerTemplate

if Sprockets.respond_to?(:register_engine)
 args = ['.es6', Tilt::ES6ModuleTranspilerTemplate]
 args << { mime_type: 'text/ecmascript-6', silence_deprecation: true } if Sprockets::VERSION.start_with?("3")
 Sprockets.register_engine(*args)
end

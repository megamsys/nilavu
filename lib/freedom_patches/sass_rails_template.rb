# sass-rails expects an actual file to exists when calling `@import`. However,
# we don't actually create the files for our special imports but rather inject
# them dynamically.
module Nilavu
  module Sprockets
    module Resolve
      def resolve(path, options = {})
        return [path, []] if NilavuSassImporter.special_imports.has_key?(File.basename(path, '.scss'))
        super
      end
    end
  end
end

# Call `prepend` directly once we drop support for Ruby 2.0.0.
Sprockets::Base.send(:prepend, Nilavu::Sprockets::Resolve)

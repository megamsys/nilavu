# barber patches to re-route raw compilation via ember compat handlebars
#

module Barber
  class EmberCompatPrecompiler < Barber::Precompiler

    def sources
      [File.open("#{Rails.root}/vendor/assets/javascripts/handlebars.js"), precompiler]
    end

    def precompiler
    @precompiler ||= StringIO.new <<END
      var Nilavu = {};
      #{File.read(Rails.root + "app/assets/javascripts/nilavu/lib/ember_compat_handlebars.js")}
      var Barber = {
        precompile: function(string) {
          return Nilavu.EmberCompatHandlebars.precompile(string,false).toString();
        }
      };
END
    end
  end
end

class Ember::Handlebars::Template
  def precompile_handlebars(string)
    "Nilavu.EmberCompatHandlebars.template(#{Barber::EmberCompatPrecompiler.compile(string)});"
  end
  def compile_handlebars(string)
    "Nilavu.EmberCompatHandlebars.compile(#{indent(string).inspect});"
  end
end

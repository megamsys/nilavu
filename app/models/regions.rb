require_dependency 'site_settings/yaml_loader'


class Regions

    # category = regions, name = chennai, opts = has hash.
    def self.load_settings(file)
        loaded_regions = Hash.new
        SiteSettings::YamlLoader.new(file).load do |category, name, default, opts|
            loaded_regions[name] = opts
        end

        loaded_regions
    end



    def self.refresh!
        load_settings(File.join(ENV['MEGAM_HOME'], 'regions.yml'))
    end
end

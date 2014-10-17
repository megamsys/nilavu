module MainDashboardsHelper
def mkp_config
    YAML.load(File.open("#{Rails.root}/config/marketplace_addons.yml", 'r'))
  end

def get_type(name)
   @type = ""
    mkp_config.each do |mkp, addon|
      if mkp == name
        @type = addon["type"]
      end
    end
    @type
 end
 

end

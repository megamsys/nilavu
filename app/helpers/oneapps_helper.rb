module OneappsHelper

def mkp_config
    YAML.load(File.open("#{Rails.root}/config/marketplace_addons.yml", 'r'))
  end

  def change_runtime(deps, runtime)
    project_name = File.basename(deps).split(".").first
    if /<projectname>/.match(runtime)
      runtime["unicorn_<projectname>"] = "unicorn_" + project_name
    end
    runtime
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

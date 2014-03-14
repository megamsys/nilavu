module MarketplaceHelper
  
  def mkp_config
    YAML.load(File.open("#{Rails.root}/config/marketplace_addons.yml", 'r'))
  end
  
  def mkp_pricing
    YAML.load(File.open("#{Rails.root}/config/pricingTable.yml", 'r'))
  end
  
  def get_predef_name(name)
    @p_name = "" 
    mkp_config.each do |mkp, addon| 
      if addon["name"] == name     
         @p_name = addon["predef_name"]         
      end   
    end
    @p_name    
  end
  
  def get_deps_scm(name)
    @scm = "" 
    mkp_config.each do |mkp, addon| 
      if addon["name"] == name     
         @scm = addon["deps_scm"]         
      end   
    end
    @scm    
  end
  
  def get_pricing  
    mkp_pricing
  end
  
end

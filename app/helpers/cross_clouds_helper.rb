module CrossCloudsHelper
  def cross_cloud    
    cc_list = Array.new
    cc_config.each do |cc, cloud|      
     cc_list.push cloud["name"]
    end
    #[ "Amazon EC2", "hp cloud", "Google cloud Engine"]
    cc_list
  end
  
  def cc_config
    YAML.load(File.open("#{Rails.root}/config/cross_clouds.yml", 'r'))
  end
  
  def cc_type(name)
    @type = "" 
    cc_config.each do |cc, cloud| 
      if cloud["name"] == name     
         @type = cloud["type"]         
      end   
    end
    @type    
  end  
end

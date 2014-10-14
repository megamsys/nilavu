module CrossCloudsHelper
  def cross_cloud
    cc_list = Array.new
    cc_config.each do |cc, cloud|
     cc_list.push cloud["name"]
    end
    cc_list
  end

  def cross_cloud_image
    cc_list = Array.new
    cc_config.each do |cc, cloud|
     cc_list.push cloud["image"]
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

  def cross_cloud_bucket
    Rails.configuration.storage_crosscloud
  end

 def ssh_files_bucket
    puts "--> ssh_files_bucket #{Rails.configuration.storage_sshfiles}"
    Rails.configuration.storage_sshfiles
  end

  def cloud_tool_setting_bucket
    Rails.configuration.storage_cloudtool
  end

  if Rails.configuration.storage_type == 's3'
    def vault_s3_url
      Rails.configuration.storage_server_url+"/"+cross_cloud_bucket
    end

    def cloudtool_base_url
      Rails.configuration.storage_server_url+"/"+cloud_tool_setting_bucket
    end  
  end


  def get_provider_value(prov)
   @value = ""
    cc_config.each do |cc, cloud|
      if cloud["name"] == prov
         @value = cloud["value"]
      end
    end
    @value
  end

end

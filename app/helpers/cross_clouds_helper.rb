##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
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


  if Rails.configuration.storage_type == 's3'
    def vault_s3_url
      Rails.configuration.storage_server_url+"/"+cross_cloud_bucket
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

  #=======================> AWS <========================
  def list_aws_data(access_key, secret_key, region)
    connection = Fog::Compute.new(
    :provider => 'AWS',
    :aws_access_key_id => "#{access_key}",
    :aws_secret_access_key => "#{secret_key}",
    :region => "#{region}" )
    #List Images
    @aws_imgs=[]
    img = connection.images.all({"owner-id" => "915134024303"})
    img.each do |i|
      @aws_imgs.push({"id" => "#{i.id}", "name" => "#{i.name}"})
    end

    #List Flavors
    @aws_flavors=[]
    connection.flavors.each do |f|
      @aws_flavors.push({"id" => "#{f.id}", "ram" => "#{f.ram}", "core" => "#{f.cores}", "disk" => "#{f.disk}"})
    end

    #List Keypairs
    @aws_keypairs=[]
    connection.key_pairs.each do |k|
      @aws_keypairs.push("#{k.name}")
    end

    #List Securitygroups
    @aws_groups=[]
    connection.security_groups.each do |s|
      @aws_groups.push("#{s.name}")
    end

    return @aws_imgs, @aws_flavors, @aws_keypairs, @aws_groups

  end

  #=======================> HP <========================
  def list_hp_data(access_key, secret_key, tenant_id, zone)
    avl_zone = hp_availability_zone(zone)
    connection = Fog::Compute.new(
    :provider => 'HP',
    :version => :v2,
    :hp_auth_uri => 'https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/',
    :hp_access_key => "#{access_key}",
    :hp_secret_key => "#{secret_key}",
    :hp_tenant_id => "#{tenant_id}",
    :hp_avl_zone => "#{avl_zone}" )

    netconnection = Fog::HP::Network.new(
    :hp_auth_uri => 'https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/',
    :hp_access_key => "#{access_key}",
    :hp_secret_key => "#{secret_key}",
    :hp_tenant_id => "#{tenant_id}",
    :hp_avl_zone => "#{avl_zone}" )

    #List Groups
    @hp_groups=[]
    netconnection.security_groups.sort_by(&:name).each do |group|
      @hp_groups.push("#{group.name}")
    end

    #List Images
    @hp_imgs=[]
    img = connection.images.all
    img.each do |i|
      if (i.name == "megam-trusty - Partner Image" || i.name == "CentOS 7 x86_64 (2014-09-29) - Partner Image")
      @hp_imgs.push({"id" => "#{i.id}", "name" => "#{i.name}"})
        end

    end

    #List Flavors
    @hp_flavors=[]
    connection.flavors.each do |f|
      @hp_flavors.push({"id" => "#{f.id}", "name" => "#{f.name}"})
    end

    #List Keypairs
    @hp_keypairs=[]
    connection.key_pairs.each do |k|
      @hp_keypairs.push("#{k.name}")
    end

    return @aws_imgs, @aws_flavors, @aws_keypairs, @hp_groups

  end

  def hp_availability_zone(zone)
    case "#{zone}"
    when 'us-east'
      return 'region-b.geo-1'
    else
    return 'region-a.geo-1'
    end
  end

  #============GOGRID===========
  def list_gogrid_data(access_key, secret_key)
    connection = Fog::Compute.new(
    :provider => 'GoGrid',
    :go_grid_api_key => "#{access_key}",
    :go_grid_shared_secret => "#{secret_key}")

    #List Images
    @gogrid_imgs=[]
    img = connection.images.all
    img.each do |i|
      @gogrid_imgs.push({"id" => "#{i.id}", "name" => "#{i.name}"})
    end

    #List Flavors
    @gogrid_flavors=[]
    connection.flavors.each do |f|
      @gogrid_flavors.push({"id" => "#{f.id}", "ram" => "#{f.ram}", "core" => "#{f.cores}", "disk" => "#{f.disk}"})
    end

    #List Keypairs
    @gogrid_keypairs=[]
    connection.key_pairs.each do |k|
      @gogrid_keypairs.push("#{k.name}")
    end

    #List Securitygroups
    @gogrid_groups=[]
    connection.security_groups.each do |s|
      @gogrid_groups.push("#{s.name}")
    end

    return @gogrid_imgs, @gogrid_flavors, @gogrid_keypairs, @gogrid_groups

  end

  #=============================>>ProfitBricks<<=================================

  def list_profitbricks_data(access_key, secret_key)

    Profitbricks.configure do |config|
      config.username = "#{access_key}"
      config.password = "#{secret_key}"
    end
    @profitbricks_imgs = []
    img = Image.all
    img.each do |i|
      @profitbricks_imgs.push({"id" => "#{i.id}", "name" => "#{i.name}"})
    end
    return @profitbricks_imgs


 end





  #=======================> Opennebula <========================
  def list_one_data(access_key, secret_key, region)
    connection = Fog::Compute.new(
    {
      :provider => 'OpenNebula',
      :opennebula_username => "#{access_key}",
      :opennebula_password => "#{secret_key}",
      :opennebula_endpoint => "#{region}"
    } )


    #List Flavors
    @one_flavors=[]
    connection.flavors.each do |f|
      @one_flavors.push({"id" => "#{f.id}", "name" => "#{f.name}", "image" => "#{f.disk["IMAGE"]}", "ram" => "#{f.memory}"})
    end

    return @one_flavors
  end
 end

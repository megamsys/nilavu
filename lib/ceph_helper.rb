class CephHelper

  attr_accessor :access_key_id
  attr_accessor :secret_access_key

  def initialize(opts)
    raise Nilavu::InvalidParameters.new(opts.to_s) if opts.blank?

    ceph_parms.each do |name|
      send("#{name}=", opts[name])
    end

    check_missing_site_settings
  end

  def new_bucket(name)
    ceph_buckets.build(name).save
  end

  #forcefully delete
  def destroy_bucket(name)
    ceph_bucket(name).destroy(true)
  end

  def upload(bucket, unique_filename, content, options={})
    obj = ceph_bucketobjects(bucket).build(unique_filename)
    obj.content = content
    obj.save
  end

 def temporary_url(bucket, unique_filename)
   obj = ceph_bucketobjects(bucket).build(unique_filename)
   obj.temporary_url
 end

  #forcefully delete
  def destroy_object(name, key)
    ceph_bucketobject(name,key).destroy
  end

  def ceph_bucket(name)
    ceph_buckets.find(name)
  end

  def ceph_bucketobjects(bucket)
    ceph_bucket(bucket).objects
  end

  def ceph_bucketobject(bucket, name)
    if  cbo = ceph_bucketobjects(bucket)
      return  cbo.find(name)
    end
    raise Nilavu::NotFound.new('ceph bucket object not found')
  end

  def ceph_buckets
    ceph_resource.buckets
  end


  private

  def ceph_resource
    opts ||={}

    ceph_parms.each {|cp| opts[cp] = send("#{cp}")}
    if  SiteSetting.ceph_gateway
      opts[:host]    = SiteSetting.ceph_gateway
      opts[:timeout] = SiteSetting.ceph_gateway_timeout
    end
      opts[:use_ssl] = true
    S3::Service.new(opts)
  end

  def ceph_parms
    [:access_key_id, :secret_access_key]
  end

  def check_missing_site_settings
    raise Nilavu::SiteSettingMissing.new("ceph_gateway") if SiteSetting.ceph_gateway.blank?
  end
end

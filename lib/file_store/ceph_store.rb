require_dependency "ceph_helper"

class CephStore

  def initialize(ceph_parms, name)
    @ceph_helper = CephHelper.new(ceph_parms)
    @bucket_name = name
  end

  def store_upload(upload, content_type = nil)
    store_file(upload, filename: upload.original_filename, content_type: content_type)
  end

  def store_file(upload, opts={})
    filename      = opts[:filename].presence
    content_type  = opts[:content_type].presence

    # stored uploaded are public by default (turn on ACLs later)
    options = {  }#acl: "public-read"

    # add a "content type" header when provided
    options[:content_type] = content_type if content_type

    content = open(upload)
    # if this fails, it will throw an exception

    @ceph_helper.upload(@bucket_name, filename, content, options)
    # return the upload url
    "#{absolute_base_url}/#{filename}"
  end

  def remove_file(url)
    return unless has_been_uploaded?(url)
    @cep_helper.remove(url, true)
  end

  def has_been_uploaded?(url)
    return false if url.blank?
    return true if url.start_with?(absolute_base_url)
    false
  end

  def absolute_base_url
    @absolute_base_url ||=   "//#{SiteSetting.ceph_gateway}"
  end

  def external?
    true
  end
end

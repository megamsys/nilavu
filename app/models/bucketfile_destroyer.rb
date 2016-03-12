# destroy bucket file using ceph helper
class BucketFileDestroyer


  def initialize(ceph_access)
    @ceph  = CephHelper.new(ceph_access)
    
    @bucket_name = ceph_access[:bucket_name]
    @bucketfile_name = ceph_access[:key]

    ensure_bucket_to_destroy?
  end

  def perform(action=nil)
    raise Nilavu::InvalidParameters unless @ceph.present?

    @ceph.destroy_object(@bucket_name, @bucketfile_name)
  end

  private

  def ensure_bucket_to_destroy?
    raise Nilavu::InvalidParameters unless @bucket_name && @bucketfile_name
  end
end

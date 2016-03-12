# create bucket on the ceph helper
class BucketDestroyer


  def initialize(ceph_access)
    @ceph  = CephHelper.new(ceph_access)
    @bucket_name = ceph_access[:id]

    ensure_bucket_to_destroy?
  end


  def perform(action=nil)
    raise Nilavu::InvalidParameters unless @ceph.present?

    @ceph.destroy_bucket(@bucket_name)
  end

  private

  def ensure_bucket_to_destroy?
    raise Nilavu::InvalidParameters unless @bucket_name
  end

end

# create bucket on the ceph helper
class BucketCreator

  def initialize(ceph_access)
    @ceph  = CephHelper.new(ceph_access)
    @bucket_name = ceph_access[:id]

    ensure_bucket_to_create?
  end


  def perform(force=false)
    raise Nilavu::InvalidParameters unless @ceph.present?

    @ceph.new_bucket(@bucket_name)
  end

  private

  def ensure_bucket_to_create?
    raise Nilavu::InvalidParameters unless @bucket_name
  end

end

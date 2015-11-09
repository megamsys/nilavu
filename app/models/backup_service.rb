class BackupService
  attr_reader :cephs3, :buckets

  class MegamBackupError < StandardError; end

  class CephConnectFailure < MegamBackupError; end

  class BucketsNotFound < MegamBackupError; end

  class DuplicateBucketError < MegamBackupError; end


  def initialize(parms)
    @cephs3 = S3::Service.new(access_key_id: parms[:ceph_access_key],
    secret_access_key: parms[:ceph_secret_key], host: endpoint)
    @buckets = cephs3.buckets
  end

  private
  def endpoint
    Ind.backup.host
  end
end

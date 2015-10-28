class BackupFascade
	attr_reader :cephs3

	class MegamBackupError < StandardError; end

	class CephConnectFailure < MegamBackupError; end

	class BucketsNotFound < MegamBackupError; end

	class DuplicateBucketError < MegamBackupError; end


	def initialize(parms)
		@cephs3 = S3::Service.new(access_key_id: parms[:access_key], secret_access_key: parms[:secret_key], host: endpoint)
	end


	def self.sign(parms)
		S3::Signature.generate(request: S3::Service.service_request(:put), access_key_id: params[:access_key],
		secret_access_key: params[:secret_key])
	end

	protected

	def cephs3
		@cephs3
	end

	def endpoint
		Ind.backup.host
	end
end

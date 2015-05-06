module SshHelper

def ssh_files_bucket
  Rails.configuration.storage_sshfiles
end

unless Rails.configuration.storage_type == 's3'
  def vault_s3_url
    Rails.configuration.storage_server_url+"/"+cross_cloud_bucket
  end
end

end

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

class BackupUser < BaseFascade
  attr_reader :client # radosgw client

  BUCKET = 'bucket'.freeze

  def initialize(host, username, user_password)
    @client = CEPH::Radosgw.new(ipaddress: "#{host}",
                                username: "#{username}",
                                user_password: "#{user_password}"
                               )
  end

  # creates a new account
  def account_create(uid)
    user_hash = @client.user_create("#{uid}")
    Rails.logger.debug '> Radosgw: Account create'
    user_json = user_hash.to_json
    storage = Storage.new(BUCKET)
    storage.upload(uid, user_json, 'application/json')
    user_hash
  end

  # usage of an account
  def account_usage(uid)
    usage_hash = @client.user_usage("#{uid}")
    Rails.logger.debug '> Radosgw: Account usage'
    usage_hash
  end
end

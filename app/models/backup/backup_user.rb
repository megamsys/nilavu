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
module Backup
  class BackupUser
    attr_reader :radosgw # radosgw client

    STORAGES_BUCKET = 'storages'.freeze

    def initialize
      @radosgw = CEPH::User.new(username: radosadmin,
        user_password: radosadmin_password,
      ipaddress: endpoint)
    end

    # Check the account's existance
    def exists?(uid)
      @radosgw.exists("#{uid}")
    end

    # creates a new account
    def create(uid, display_name)
      radosuser = @radosgw.create("#{uid}","#{display_name}")
      ## we will have to move this thing out of this code.
      Nilavu::DB::GSRiak.new(STORAGES_BUCKET).upload(uid, radosuser.to_json, 'application/json')
      radosuser
    end

    # usage of an account
    def usage(uid)
      @radosgw.usage("#{uid}")
    end

    private
    def radosgw
      @radosgw
    end

    def endpoint
      Ind.backup.host
    end

    def radosadmin
      Ind.backup.username
    end

    def radosadmin_password
      Ind.backup.password
    end
  end
end

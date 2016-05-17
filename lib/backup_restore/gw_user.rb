##
## Copyright [2013-2016] [Megam Systems]
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
module GWUser

  # Check the account's existance
  def self.exists?(email)
    ensure_gw_is_available?

    radosgw.exists(email)
  end

  def self.find_by_email(email)
    ensure_gw_is_available?

    radosgw.info(email)
  end

  # creates a new account
  def self.save(email, name)
    ensure_gw_is_available?
   radosgw.create(email, name)
  end
  # usage of an account
  def self.usage(email)
    ensure_gw_is_available?

    radosgw.usage(email)
  end

  private

  def self.ensure_gw_is_available?
    return Nilavu::NotFound unless radosgw
  end

  def self.radosgw
    raise Nilavu::InvalidParameters if !SiteSetting.ceph_username || !SiteSetting.ceph_password || !SiteSetting.ceph_gateway
    CEPH::User.new(username: SiteSetting.ceph_username,
      user_password: SiteSetting.ceph_password,
    ipaddress:   SiteSetting.ceph_gateway)
  end

end

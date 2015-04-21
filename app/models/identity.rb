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
class Identity
  def initialize()
    @email = nil
    @uid = nil
    @provider = nil
    @created_at = nil
    @updated_at = nil
  end

  def builder(auth, email)
    hash = {
      "email" => email,
      "uid" => auth[:uid],
      "provider" => auth[:provider],
      "created_at" => Time.zone.now,
      "updated_at" => ""
    }

    hash.to_json
  end

  def create_from_omniauth(auth, email)
    hash = builder(auth, email)
    result = true
    res_body = MegamRiak.upload("identity", auth[:uid], hash, "application/json")
    if res_body.class == Megam::Error
    result = false
    end
    result
  end

  def find_from_omniauth(auth)
    find_by_uid(auth[:uid])
  end

  def find_by_uid(uid)
  result = nil
     res = MegamRiak.fetch("identity", uid)
     if res.class != Megam::Error
        result = res.content.data
    end
    result
  end

end

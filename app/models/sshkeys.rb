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
class Sshkeys < BaseFascade

  attr_reader :ssh_keys
  def initialize()
    @ssh_keys = []
  end

  def list(api_params, &block)
    raw = api_request(api_params, SSHKEYS, LIST)
    @ssh_keys = filterkeys(raw[:body]) unless raw == nil
    yield self  if block_given?
    return self
  end

  private

  def filterkeys(ssh_keys_collection)
    ssh_keys = []
    ssh_keys_collection.each do |sshkey|
      ssh_keys << {:name => sshkey.name, :created_at => sshkey.created_at.to_time.to_formatted_s(:rfc822)}
    end
   ssh_keys.sort_by {|vn| vn[:created_at]}
  end

end
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
module MarketplaceHelper


  # We need to rewrite.
  # the constants should be moved to a super Assembly class.
  # The helper is getting bloated.
  def set_repotype(cattype)
    case cattype
    when Api::Assemblies::APP
      'git'
    else
      'image'
    end
  end

  # We need to rewrite.
  # the constants should be moved to a super Assembly class.
  # The helper is getting bloated.
  def enable_ci(cattype, selected_scm)
    if cattype == Api::Assemblies::APP && selected_scm == 'byoc_scm'
      'true'
    else
      'false'
    end
  end


  def parse_key_value_pair(array, search_key)
    array.map do |pair|
      return pair['value'] if pair['key'] == search_key
    end
    ''
  end

  def parse_operations(array, search_key)
    array.map do |pair|
      return pair['operation_requirements'] if pair['operation_type'] == search_key
    end
  end

    def unbound_apps(apps)
    unbound_apps = []
    unbound_apps << 'Unbound service'
    apps.map { |c| unbound_apps << [c[:name], c[:name] + ':' + c[:aid] + ':' + c[:cid]] }
    unbound_apps
  end
end

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
module MarketplaceHelper
  # generates a random name work for the launch
  # eg: awesome . megam.co
  def launch_namegen
    @launch_namegen = /\w+/.gen
    @launch_namegen.downcase
  end

  # the category comes like
  #  1-Dew
  #  2-BYOC
  # strip the numeric and the dash(-)

  #def trim_category(ck)
  #  /[a-zA-Z ]+/.match(ck)
  #end


  def trim_category(ck)
    case ck
    when '1'
      'TORPEDO'
    when '2'
      'BYOC'
    when '3'
      'SERVICE'
    when '4'
      'MICROSERVICES'
    when '5'
      'ANALYTICS'
    when '6'
      'COLLABORATION'
    when '7'
      'Just do one thing in an unikernel.'
    else
      '! Missing category !'
    end

  end

  def category_description(ck)
    case ck
    when '1'
      'Get your own compute power'
    when '2'
      'Get started with a new app'
    when '3'
      'Make your applications more hungry'
    when '4'
      'Enrich Megam with awesome addons'
    when '5'
      'Actionable insights in minutes'
    when '6'
      'Collaboration done in minutes'
    when '6-Unikernel'
      'Just do one thing in an unikernel.'
    else
      '! Missing category !'
    end
  end

  #for the Assenbly type and enabled status

  def set_repotype(cattype)
    case cattype
    when 'BYOC'
      'git'
    else
      'image'
    end
  end

  def enable_ci(cattype, radio_app_scm)
    case cattype
    when 'BYOC'
      case radio_app_scm
      when 'byoc_scm'
        'true'
      else
        'false'
      end
    else
      'false'
    end
  end
  # from a bunch of plans, we match the plan for a version
  # eg: debian jessie 7, 8
  def match_plan_for(mkp, version)
   mkp['plans'].select  { |tmp| tmp['version'] == version }.reduce { :merge }
   end

  def parse_key_value_pair(array, search_key)
    array.map do |pair|
      return pair["value"] if pair["key"] == search_key
    end
    return ""
  end

  def parse_operations(array, search_key)
    array.map do |pair|
      return pair["operation_requirements"] if pair["operation_type"] == search_key
    end
    return []
  end

  # stick all the versions (debian 7, 8 and the first version 7 or the passed version 8)
  def pressurize_version(mkp,version)
    versions = []
    versions = mkp.plans.map { |c| c['version'] }.sort
    tmkp = mkp.to_hash
    tmkp['versions'] = versions
    tmkp['sversion'] = version || versions[0]
    tmkp
  end

  def unbound_apps(apps)
    unbound_apps  = []
    unbound_apps << "Unbound service"
    apps.map{ |c| unbound_apps << [c[:name], c[:name]+":"+c[:aid]+":"+c[:cid]] }
    unbound_apps
  end

 end

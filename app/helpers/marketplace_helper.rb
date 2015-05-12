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
  def trim_category(ck)
    /[a-zA-Z ]+/.match(ck)
  end

  def category_description(category)
    case category
    when '1-Dew'
      'Get started with a VM'
    when '2-BYOC'
      'Get started with a new app'
    when '3-App Boilers'
      'Make your applications more hungry'
    when '4-Platform'
      'Enrich Megam with awesome addons'
    when '5-Analytics'
      'Actionable insights in minutes'
    when '6-Unikernel'
      'Just do one thing in an unikernel.'
    else
      '! Missing category !'
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
  end
   
 end

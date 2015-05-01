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

  TYPE         = "type".freeze
  PREDEF_NAME  = "predef_name".freeze
  DEPS_SCM     = "deps_scm".freeze
  LINKS        = "links".freeze
  BASIC_COMBOS = "basic_combos".freeze

  def get_type(name)
   @type = ""
   Rails.configuration.YUMMY_MARKET.each do |mkp, addon|
      if mkp == name
        @type = addon[TYPE]
      end
    end
    @type
 end

  def get_predef_name(name)
    @p_name = ""
    Rails.configuration.YUMMY_MARKET.each do |mkp, addon|
      if mkp == name
        @p_name = addon[PREDEF_NAME]
      end
    end
    @p_name
  end

  def get_deps_scm(name)
    @scm = ""
    Rails.configuration.YUMMY_MARKET.each do |mkp, addon|
      if addon["name"] == name
        @scm = addon[DEPS_SCM]
      end
    end
    @scm
  end

  def get_category_description(category)
    case category
    when "Starter packs"
      'Get started with a new app'
    when "Platform"
      'Enrich Megam with awesome addons'
    when "App Boilers"
      'Make your applications more hungry'
    when "Runtime"
      'Get started with a new app'
    else
    ''
    end
  end

 def get_doc_link(name)
   @link = ""
   Rails.configuration.YUMMY_MARKET.each do |mkp, addon|
      if mkp == name
        @link = addon[LINKS]
      end
    end
    @link
 end

 def get_combos(name)
   @combo = ""
   Rails.configuration.YUMMY_MARKET.each do |mkp, addon|
      if mkp == name
        @combo = addon[BASIC_COMBOS]
      end
    end
    @combo
 end




end

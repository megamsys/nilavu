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
module Sources
  extend self
  def plugin_clazz(type, name)
    "Sources::#{type.camelize}::#{name.camelize}".constantize
  end

  def available_source_types
    @available_source_types ||= begin
    path = Rails.root.join("app/models/sources")
    Dir["#{path}/*"].map { |directory| Pathname.new(directory).basename }.map(&:to_s)
    end
  end

  available_source_types.each do |type|
    define_method("#{type}_plugin") do |name|
      plugin_clazz(type, name).new
    end
  end

  def widget_type_to_source_type(type)
    logger.debug("----- widget_type_to_source =>" + type)
    case type
    when "graph" then "datapoints"
    when "meter" then "number"
    else
    type
    end
  end

  def sources
    result = {}
    available_source_types.each do |type|
      type_result = {}
      source_names(type).each do |name|
        type_result[name] = source_properties(type, name)
      end
      result[type] = type_result
    end
    result
  end

  def [](type)
    sources[type] || []
  end

  def source_names(type)
    path = Rails.root.join("app/models/sources/#{type}")
    Dir["#{path}/*"].map { |f| File.basename(f, '.*') }.reject! { |name| name == "base" }
  end

  protected

  def source_properties(type, name)
    plugin = plugin_clazz(type, name).new
    {
      name:                     name,
      available:                plugin.available?,
      supports_target_browsing: plugin.supports_target_browsing?,
      supports_functions:       plugin.supports_functions?,
      custom_fields:            plugin.custom_fields,
      default_fields:           plugin.default_fields
    }
  end

end

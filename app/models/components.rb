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
require 'bcrypt'
require 'json'

class Components < BaseFascade

  attr_reader :components

  def initialize()
    @components= nil
  end

  def show(api_params, &block)
    @components = api_request(api_params, COMPONENTS, SHOW)[:body]
    yield @components if block_given?
    return @components
  end

  def prune
    components.take_while { |one_component| (one_component.nil? || one_component.is_a?(Megam::Error)) }
  end

end

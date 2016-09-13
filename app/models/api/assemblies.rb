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
module Api
    class Assemblies < ApiDispatcher

        attr_reader :baked
        ALL                 =  'ALL'.freeze
        TORPEDO             =  'TORPEDO'.freeze
        APP                 =  'APP'.freeze
        SERVICE             =  'SERVICE'.freeze
        ANALYTICS           =  'ANALYTICS'.freeze
        CONTAINER           =  'CONTAINER'.freeze
        COLLABORATION       =  'COLLABORATION'.freeze

        CATTYPES            =  [TORPEDO, APP, SERVICE, CONTAINER, ANALYTICS, COLLABORATION]

        START               =  'start'.freeze
        STOP                =  'stop'.freeze
        RESTART             =  'restart'.freeze
        REBOOT              =  'restart'.freeze
        DESTROY             =  'delete'.freeze
        TERMINATED          =  'destroying'.freeze
        LAUNCHING           =  'LAUNCHING'.freeze
        SOURCE              =  'source'.freeze


        def initialize
            @baked = []
            super(true) # swallow 404 errors for assemblies.
        end

        # The list returns a list of assemblies, apps, services.
        # we also need the spun vms, apps, services
        # here is the  tree for us.
        # You can have as many assembly inside assemblies.
        # for the sake of a simple verbosology, we call plural assemblys as assembly_collection.
        # There exists a need to cyclically dug inside as we only retrieve the ids of our assemblies structure.
        # The following has 1 assembly and 2 components.
        #  -- assemblies :
        #      --assembly
        #           ---components
        #                   -- component1 : app
        #                   -- component2 : service
        # currently if there are no components then we consider it a plain VM.
        # an additional field in assembly indicates if its a plain VM (INSTANCE) or not.
        def list(api_params, &_block)
            raw = api_request(ASSEMBLIES, LIST, api_params)
            dig_assembly(raw[:body], api_params) unless raw.nil?
            yield self  if block_given?
            self
        end

        def create(api_params)
            bld_data = build_data(api_params)
            api_request(ASSEMBLIES, CREATE, api_params.merge(bld_data))
        end

        def build_data(api_params)
            { name: '',
                assemblies: [Megam::Mixins::Assemblies.new(api_params).to_hash],
                inputs: [],
                org_id: api_params[:org_id]
            }
        end
        private
        # The /assemblies just returns an id of assembly. dig recursively to get the full content of it.
        #     assemblies : :id  => ASM0001
        #          assembly: :id => ASC0001
        #              component :id => CMP0001
        def dig_assembly(tmp_assemblies_collection, api_params)
            # First step iterate over the [Aid1, Aid2] and make @baked => A[ASM1, ASM2..ASMn]
            @baked = tmp_assemblies_collection.map do |one_assemblies|
                a1 = one_assemblies.assemblies.map do |one_assembly|
                    unless one_assembly.empty?
                        Api::Assembly.new.show(api_params.merge(id: one_assembly, asms_id: one_assemblies.id)).baked
                    end
                end

                a1
            end
            filter(api_params[:filter]) unless api_params[:filter] == ALL
            Rails.logger.debug "\033[36m>-- ASB'S: #{@baked.class} START\33[0m"
            Rails.logger.debug "\033[1m#{@baked.to_yaml}\33[22m"
            Rails.logger.debug "\033[36m> ASB'S: END\033[0m"
        end

        def filter(type)
          @baked = @baked.find_all { |asm| asm[0][0].tosca_type.split(".")[1] == type.downcase }
        end
    end
end

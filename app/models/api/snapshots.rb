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
    class Snapshots < ApiDispatcher

        attr_reader :snapshots_all, :snapshots_per

        def initialize
            @snapshots_all = []
            @snapshots_per = []
            super(true) # swallow 404 errors for assemblies.
        end

        def perlist(params, &_block)
            #raw = api_request(SNAPSHOTS, SHOW, params)
            #        dig_snapshots(raw[:body]) unless raw.nil?
            dig_snapshots(params)
            yield self  if block_given?
            self
        end

        def list(params, &_block)
            raw = api_request(SNAPSHOTS, LIST, params)
            #        dig_snapshots(raw[:body]) unless raw.nil?
            dig_snapshots(params)
            yield self  if block_given?
            self
        end

        def dig_snapshots(rwa)

            @snapshots_per = [{
                name: "snap0001",
                snap_id: "SNP0XARB0001",
                asm_id: 'ASM00000001',
            created_at:  '21/11/2016 20:30:00'}]

            @snapshots_all = [{
                name: "snap0002",
                snap_id: "SNP0XARB0002",
                asm_id: 'ASM00000002',
                created_at:  '22/11/2016 21:30:10'},{
                name: "snap0004",
                snap_id: "SNP0XARB0004",
                asm_id: 'ASM00000004',
            created_at:  '23/11/2016 22:30:20'}]
        end
    end
end

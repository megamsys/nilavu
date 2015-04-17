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
class VmsController < ApplicationController
  respond_to :html, :js
  
  def index
    if !!current_user
      @user_id = current_user["email"]
      @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
      @vm_counter = 0
      if @assemblies != nil
        @assemblies.each do |asm|
          if asm.class != Megam:: Error
            asm.assemblies.each do |assembly|
              if assembly != nil
                if assembly[0].class != Megam::Error
                   if assembly[0].components.length == 0 
                    @vm_counter = @vm_counter + 1
                  end
                end
              end
            end
          end
        end
      end
    else
    redirect_to signin_path and return
  end
end

end
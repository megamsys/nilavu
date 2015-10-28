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
class SettingsController < NilavuController
	respond_to :html, :js

	#TO-DO later: This will only have cloud and will get turned on, if somebody configures in nilavu.yml
	def new
	end

	def index
		logger.debug "--> #{self.class} : index entry"
		list_clouds
	end

	def show
		@cc_msg = nil
		@cts_msg = nil
		if params[:type] == "cross_cloud"
			@cc_msg = params[:type]
			@cts_msg = nil
			@cross_clouds = ListPredefClouds.perform(force_api[:email], force_api[:api_key])
			@cross_cloud = @cross_clouds.lookup(params[:id])
		end
		respond_to do |format|
			format.js do
				respond_with(@cc_msg, @cts_msg, @cross_cloud, @cloud_tool_setting, :layout => !request.xhr? )
			end
		end
	end

	def destroy
		del_settings = DeletePredefCloud.perform(params[:id], force_api[:email], force_api[:api_key])
		if del_settings.class != Megam::Error
			@res_msg = "Cloud_Setting deleted successfully"
		else
			@res_msg = "Sorry! Cloud_Setting was not deleted successfully"
		end
		respond_to do |format|
			format.js do
				respond_with(@res_msg, :layout => !request.xhr? )
			end
		end
	end

	private

	def list_clouds
		logger.debug "> #{self.class}: list_clouds"
		@cross_clouds_collection = ListPredefClouds.perform( force_api[:email], force_api[:api_key])
		if @cross_clouds_collection.class != Megam::Error
			@cross_clouds = []
			cross_clouds = []
			@cross_clouds_collection.each do |pre_cl|
				cross_clouds << {:name => pre_cl.name, :type => pre_cl.spec[:type_name], :created_at => pre_cl.created_at.to_time.to_formatted_s(:rfc822)}
			end
			@cross_clouds = cross_clouds.sort_by {|vn| vn[:created_at]}
		end
	end
end

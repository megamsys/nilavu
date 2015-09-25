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

class Storage < BaseFascade

def get_buckets
	bucket_array = []
	service = S3::Service.new(:access_key_id => "5UM3I9DFCN0WG4KJPJ8O", :secret_access_key => "h9NrW6K2GgcJN+Ww47pvOlJU22tA0C4G8GIiGd6H")	
	service.buckets.each do |bkt|
		count=0
		size=0
		bkt.objects.each do |obj|
			count=count+1
			size+=obj.size.to_i
		end
		bucket_array.push({:bucket_name => "#{bkt.name}", :size => size, :create_at => "22-May-2013" })
	end
	bucket_array
end

end

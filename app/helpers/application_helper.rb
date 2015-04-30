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
module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Megam"
    if page_title.empty?
    base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  #spinner tag helper called from views which embeds a 64px circular gray spinner image.
  #We may change this name to big_circle_spinner_tag, for now lets leave it.
  def spinner_tag id
    #Assuming spinner image is called "spinner.gif"
    image_tag("ajax_64.png", :id => id, :alt => "Loading....", :style => "display:none")
  end


  #spinner tag helper called from views which embeds a 40px circular gray spinner image.
  #We may change this name to small_circle_spinner_tag, for now lets leave it.
  def mini_spinner_tag id
    #Assuming spinner image is called "spinner.gif"
    image_tag("ajax_40.png", :id => id, :alt => "Loading....", :style => "display:none")
  end

  def normalized_filename(file)
    # file.to_s.gsub(".html", "").gsub(".erb", "")
    # file.to_s.gsub(".html", "").gsub(".erb", "")
    file.to_s
  end

  def normalize_template_name(name)
    # normalized_filename(name.to_s).gsub("/", "-")
    normalized_filename(name.to_s)#.gsub("/", "-")
  end

  def script_tag_for_all_templates
    templates_dir = Rails.root.join("app/assets/javascripts/angular/templates")
    # files = Dir[templates_dir + "**/*.html"].reject {|fn| File.directory?(fn) }
    files = Dir[templates_dir + "**/*.html.erb"].reject {|fn| File.directory?(fn) }
    files.map do |file|
      id = "angular/templates/#{normalize_template_name(Pathname(file).relative_path_from(templates_dir))}"
      <<-EOF
<script type="text/ng-template" id="#{id}">
#{render :file => normalized_filename(file), :formats => [:html], :handlers => :erb}
</script>
EOF
    end.join("\n").html_safe
  end

end

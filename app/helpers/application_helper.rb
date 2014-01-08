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

  def avatar_url(user)
    if user.organization.present?
    user.organization.logo
    else
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=140"
    end
  end

  #A per page helper when passed in a sub entry link will fetch the correct help page.
  #For instance to insert the correct help link in cloud identity page, a help_entry_name with value "cloudidentity" will be passed
  #1.a link url = http://docs.megam.co/nilavu#cloudidentity can be clicked by an user to avail help in cloud identity page.
  #2.by default a link_url = http://docs.megam.co/nilavu#index can be clicked by an user to avail help (home page).
  def help_link(help_entry_name=nil)
    docs_url = "https://docs.megam.co/nilavu"

    if help_entry_name
      docs_url += "/#{help_entry_name}"
      link_text = "Help for #{help_entry_name.underscore_humanize}"
    else
      docs_url += "/#index"
      link_text ="Help"
    end
    link_to_ link_text, docs_url, { :target => '_blank'}
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

  #flash class which based on the level passed inserts the correct css types.
  #called from the partial _flash_message. eg: when passed with notice argument, it returns alert-info.
  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-danger"
    when :alert then "alert alert-danger"
    when :warning then "alert"
    end
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


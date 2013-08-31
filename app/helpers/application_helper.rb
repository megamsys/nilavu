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
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end
  
 def script_tag_for_all_custom_fields
    Widget.list_available.map do |widget|
      id = "templates-custom_fields-#{widget}"
      <<-EOF
      <script type="text/ng-template" id="#{id}">
        #{render :text => control_groups(widget), :formats => [:html], :handlers => :erb}
      </script>
      EOF
    end.join("\n").html_safe
  end

  private  

  # @source for example: number, ci, etc.
  # using ng-switch doesn't work, it breaks the form validation
  def control_groups(source)
    source = Sources.widget_type_to_source_type(source)

    source = Sources[source]
    result = []
    source.each do |key, value|
      result << "<div ng-show=\"'#{key}' == widget.source\">"
      value[:custom_fields].each do |field|
        result << control_group(key, field).html_safe
      end
      result << "</div>"
    end

    result.join.html_safe
  end

  def control_group(key, field)
    name = "#{field[:name]}"
    mandatory = field.fetch(:mandatory, false)

    <<-EOF
      <div td-field label="#{field[:title]}">
        <input name="#{name}" ng-model="widget.#{name}" type="text" ng-required="widget.source == '#{key}' && #{mandatory}"/>
      </div>
    EOF
  end

  
end


class SiteCustomization

  @cache = Rails.cache

  def self.html_fields
    %w(body_tag head_tag header mobile_header footer mobile_footer)
  end

  SiteCustomization.html_fields.each do |html_attr|
    if erb = ApplicationHelper.customtag_for_site("{html_attr}")
      self.send("#{html_attr}=", erb)
    end
  end


  SiteCustomization.html_fields.each do |html_attr|
    if self.send("#{html_attr}")
      self.send("#{html_attr}_baked=", process_html(self.send(html_attr)))
    end
  end

  def process_html(html)
    Rails.cache.fetch("sitecustomization_#{html}", expires_in: 1.day) do
      doc = Nokogiri::HTML.fragment(html)
      doc.to_s
    end
  end

  def self.enabled_key
    ENABLED_KEY.dup
  end

  def self.field_for_target(target=nil)
    target ||= :desktop

    case target.to_sym
    when :mobile then :mobile_stylesheet
    when :desktop then :stylesheet
    when :embedded then :embedded_css
    end
  end

  def self.baked_for_target(target=nil)
    "#{field_for_target(target)}_baked".to_sym
  end


  %i{header top footer head_tag body_tag}.each do |name|
    define_singleton_method("custom_#{name}") do |preview_style=nil, target=:desktop|
      preview_style ||= ENABLED_KEY
      lookup_field(preview_style, target, name)
    end
  end

  def self.lookup_field(key, target, field)
    return if key.blank?

    cache_key = key + target.to_s + field.to_s;

    lookup = @cache[cache_key]
    return lookup.html_safe if lookup
  end

  def ensure_baked!(field)
    unless self.send("#{field}_baked")
      if val = self.send(field)
        val = process_html(val) rescue ""
      end
    end
  end
end

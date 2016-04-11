class SiteCustomization

  def self.html_fields
    %w(body_tag head_tag header top mobile_header footer mobile_footer)
  end

  class << self
    attr_accessor :body_tag, :body_tag_baked, :head_tag, :head_tag_baked, :header, :header_baked
    attr_accessor :mobile_header,  :mobile_header_baked, :top, :top_baked, :mobile_header,  :mobile_header_baked
    attr_accessor :footer, :footer_baked, :mobile_footer, :mobile_footer_baked


    def process_html(html)
      doc = Nokogiri::HTML.fragment(html)
      doc.to_s
    end


    def ensure_baked!(field)
      unless self.send("#{field}_baked")
        if val = self.send(field)
          val = process_html(val) rescue ""
        end
      end
    end
  end

  SiteCustomization.html_fields.each do |html_attr|
    if erb = ApplicationHelper.customtag_for_site("#{html_attr}")
      self.send("#{html_attr}=", erb)
    end
  end

  SiteCustomization.html_fields.each do |html_attr|
    if self.send("#{html_attr}")
      self.send("#{html_attr}_baked=", process_html(self.send(html_attr)))
    end
  end


  %i{header top footer head_tag body_tag}.each do |name|
    define_singleton_method("custom_#{name}") do |target=:desktop|
      lookup_field(target, name)
    end
  end

  def self.lookup_field(target, field)
    lookup = self.send("#{field}")

    return lookup.html_safe if lookup
  end
end

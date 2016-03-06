
class UrlHelper

  def self.public_suffix(url)
    Addressable::URI.parse(url).host
  end

  def self.schemaless(url)
    url.sub(/^http:/, "")
  end

end

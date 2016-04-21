class StylesheetCache

  MAX_TO_KEEP = 50

  def self.add(target,digest,content)
      create(target, digest, content)
  end


  private

  def self.create(target, digest, content)
    #expires_in 1.year, public: true unless Rails.env == "development"
    cache_name = digest ? target.to_s + digest : target
    Rails.logger.debug "=> cache #{cache_name}"

    Rails.cache.fetch(cache_name.to_sym, expires_in: 10.minutes) do
      content
    end
  end
end

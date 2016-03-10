class MarketplacesPresenter

  #TO-DO change later
  def self.title
    I18n.t('marketplace.honeypot_title', {:apps => 'Apps', :services => 'Services'})
  end
  def self.presentable_types
    @@types ||= Enum.new(*Nilavu.default_categories.map(&:to_sym))
  end

  def self.presentable_types_muted
    @@muted_types ||= Enum.new(*Nilavu.default_categories_muted.map(&:to_sym))
  end

  def self.name_for(presentable, plural=1)
    return  I18n.t("site_settings.#{ps(presentable)}",:count => plural)
  end

  def self.description_of(presentable)
    return   I18n.t("site_settings.#{ps(presentable)}_description")
  end

  # We don't observe freewheeling in dev mode
  def self.enabled?(presentable)
    enabled?(presentable) || Rails.env.development? || !is_under_freewheeling?
  end

  private

  def self.enabled(presentable)
    presentable_types.include?(presentable) && !presentable_types_muted.include?(presentable)
  end

  def self.ps(i)
    presentable_types[i.to_i]
  end

  def is_under_freewheeling?
    SiteSettings.under_freewheeling
  end
end

class MarketplacesPresenter

  def self.presentable_types
    @presentable_types ||= Enum.new(Nilavu.default_category_types.to_a)
  end

  def self.presentable_types_muted
    @presentable_types ||= Enum.new(Nilavu.default_category_types_muted.to_a)
  end

  def self.name_for(presentable)
    return  I18n.t('site_setting.#{presentable}')
  end

  def self.description_of(presentable)
    return   I18n.t('site_setting.#{presentable}_description')
  end

  # We don't observe freewheeling in dev mode
  def self.enabled?(presentable)
    enabled?(presentable) || Rails.env.development? || !is_under_freewheeling?
  end

  private

  def self.enabled(presentable)
    presentable_types.include?(presentable) && !presentable_types_muted.include?(presentable)
  end

  def is_under_freewheeling?
    SiteSettings.under_freewheeling
  end
end

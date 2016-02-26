class HomePageConstraint
  def initialize(filter)
    @filter = filter
  end

  def matches?(request)
    provider = Nilavu.current_user_provider.new(request.env)
    homepage = provider.current_user ? SiteSetting.homepage : SiteSetting.anonymous_homepage
    homepage == @filter
  end
end

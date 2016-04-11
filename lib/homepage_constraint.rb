require_dependency 'current_user'

## there is no point having this, all it does is sets up a constraint
class HomePageConstraint

  def matches?(request)
    provider = Nilavu.current_user_provider.new(request.env)
    request.params[:email] = provider.current_user.email
    true
  end
end

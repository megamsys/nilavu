module CloudIdentitiesHelper
  def account_name
    @account_name = /\w+/.gen
  end

end

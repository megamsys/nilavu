class PasswordValidator

  def self.validate(user, opts_password)
    return true if params.has_key?(:current_password)

    user.password = params[:current_password]
    if user.find_by_email
      return true
    else
      return false
    end
  end
end

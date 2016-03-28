# The guardian is responsible for confirming access to various site resources and operations
class Guardian

  class AnonymousUser
    def blank?; true; end
    def admin?; false; end
    def staff?; false; end
    def approved?; false; end
    def launchable_categories; []; end
    def email; nil; end
  end

  def initialize(user=nil)
    @user = user.presence || AnonymousUser.new
  end

  def user
    @user.presence
  end
  alias :current_user :user

  def anonymous?
    !authenticated?
  end

  def authenticated?
    @user.present?
  end

  def is_admin?
    @user.admin?
  end

  def is_staff?
    @user.staff?
  end

  def is_developer?
    @user &&
    is_admin? &&
    (Rails.env.development? ||
      (
        Rails.configuration.respond_to?(:developer_emails) &&
        Rails.configuration.developer_emails.include?(@user.email)
      )
    )
  end

  private

  def is_me?(other)
    other && authenticated? && other.is_a?(User) && @user == other
  end

  def is_not_me?(other)
    @user.blank? || !is_me?(other)
  end

  def can_administer?(obj)
    is_admin? && obj.present?
  end

  def can_administer_user?(other_user)
    can_administer?(other_user) && is_not_me?(other_user)
  end

end

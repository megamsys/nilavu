module AppsHelper
  def book_name
    @book_name = /\w+/.gen
    @book_name.downcase
  end

  def latest_book
    current_user.apps.last
  end

end

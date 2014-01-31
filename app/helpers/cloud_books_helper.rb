module CloudBooksHelper
  def book_name
    @book_name = /\w+/.gen
    @book_name.downcase
  end

  def latest_book
    current_user.cloud_books.last
  end

  def change_runtime(deps, runtime)
    project_name = File.basename(deps).split(".").first
    if /<projectname>/.match(runtime)
      runtime["unicorn_<projectname>"] = "unicorn_" + project_name
    end
    runtime
  end

end

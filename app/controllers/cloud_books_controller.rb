class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Home", :root_path
  
  def new
    @book =  current_user.cloud_books.build
    add_breadcrumb "cloud_book_create", cloud_book_create_path

  end

  def create
    @book = current_user.cloud_books.create(params[:cloud_book])
    @domainname = @book.domain_name
    @book_id = @book.id
    if @book.save
      node_job = {:predef_name => @book.predef_name, :predef_cloud_name => @book.predef_cloud_name}
      #success = Resque.enqueue(APINodes, node_job)
    else
      render 'new'
    end

  end

  def success_form
    add_breadcrumb "cloud_book_success", success_form_path
  end

end

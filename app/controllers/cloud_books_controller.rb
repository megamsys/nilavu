class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Home", :root_path
  
  def new
    @book =  current_user.cloud_books.build
    add_breadcrumb "cloud_book_create", cloud_book_create_path

  end

  def create
    sleep 2
    @book = current_user.cloud_books.create(params[:cloud_book])
    @domainname = @book.domain_name
    @book_id = @book.id
    puts "value------> #{@domainname}"
    if @book.save         
      nodes = Hash["predefname" => "java", "predefcloudname" => "ec2_java"]
      success = Resque.enqueue(APINodes, nodes)     
    else
      render 'new'
    end
    
  end

  def success_form
    add_breadcrumb "cloud_book_success", success_form_path
  end

end

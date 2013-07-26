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
    if @book.save         
      nodes = Hash["predefname" => "java", "predefcloudname" => "ec2_java"]
      success = Resque.enqueue(APINodes, nodes)
     #redirect_to cloud_books_success_form_url(:predef_name => @book.predef_name, :predef_cloud_name => @book.predef_cloud_name ), :gflash => { :success => { :value => "Welcome #{current_user.first_name}. Your cloud book(predef) was created successfully.", :sticky => false, :nodom_wrap => true } }
     
    else
      render 'new'
    end
  end

  def success_form
    add_breadcrumb "cloud_book_success", success_form_path
  end

end

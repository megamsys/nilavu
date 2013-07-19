class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Home", :root_path
  
  def new
    @book = CloudBook.new
   
    add_breadcrumb "new", cloud_book_create_path    
    
  end

  def create
   
  end  
  
  
end

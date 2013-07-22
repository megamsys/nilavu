class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Home", :root_path
  
  def new
    @book = CloudBook.new
   
    add_breadcrumb "first step", cloud_book_create_path    
    
  end

  def cloud_book_second_step
    @book = CloudBook.new
      add_breadcrumb "second step", cloud_book_create_path  
  end
    
  
end

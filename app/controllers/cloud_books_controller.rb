class CloudBooksController < ApplicationController
  respond_to :html, :js
  add_breadcrumb "Home", :root_path
  
  def create
    add_breadcrumb "create", cloud_book_create_path
  end 
  
end
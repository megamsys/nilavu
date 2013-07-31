class CloudBooksHistoriesController < ApplicationController

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Cloud Book History", :root_path
  
  def index
    @books = current_user.cloud_books
  #@books = @cloud_books.cloud_books_histories
  end
  
  def new
  end

  def create
    @books = current_user.cloud_books.find(params[:book_id])
    @books.cloud_books_histories.create(:book_id => params[:book_id], :book_name => params[:book_name])
    redirect_to cloud_books_histories_path
  end

  

end

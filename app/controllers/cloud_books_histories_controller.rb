class CloudBooksHistoriesController < ApplicationController

  add_breadcrumb "Home", :root_path
  
  def index
    add_breadcrumb "Cloud Book History", :root_path
    @books = current_user.cloud_books
  #@books = @cloud_books.cloud_books_histories
  end

  def create
    @books = current_user.cloud_books.find(params[:book_id])
    @books.cloud_books_histories.create(:book_id => params[:book_id], :book_name => params[:book_name])
    #@cloud_runs = current_user.cloud_runs
    #Resque.enqueue(`rake resque:work QUEUE='*'`)
    #Resque.enqueue(CloudRest)
    redirect_to cloud_books_histories_path
  end

end

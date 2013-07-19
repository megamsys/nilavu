class CloudRunController < ApplicationController

  add_breadcrumb "Home", :root_path

  def running_cloud
    add_breadcrumb "Cloud Run", running_cloud_path
    @cloud_runs = current_user.cloud_runs
     #Resque.enqueue(`rake resque:work QUEUE='*'`)
    #Resque.enqueue(CloudRest)
  end
  def worker
	    Resque.enqueue(CloudRest)

  end
end

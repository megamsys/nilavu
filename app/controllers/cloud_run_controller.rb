class CloudRunController < ApplicationController

  add_breadcrumb "Home", :root_path

  def running_cloud
    add_breadcrumb "Cloud Run", running_cloud_path
    @cloud_runs = current_user.cloud_runs
  end
end

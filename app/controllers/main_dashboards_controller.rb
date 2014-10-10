class MainDashboardsController < ApplicationController


  respond_to :html
  def index
    if current_user
      breadcrumbs.add " Dashboard", :main_dashboards_path, :class => "fa fa-dashboard"      
      @user_id = current_user.id
      @launched_apps_services = current_user.apps
      @cloud_distrib = collapse_cloud_distrib
      @apps_distrib=collapse_apps_distrib
      @apps_distrib.each_pair{|k,v| @apps_distrib.store(k,v.to_i)}
    else
      redirect_to signin_path
    end
  end
  
  def visualCallback
    if current_user    
     redirect_to main_dashboards_path, :gflash => { :error => { :value => "Invalid username and password combination, Please Enter your correct megam email", :sticky => false, :nodom_wrap => true } }
    else
      redirect_to signin_path, :gflash => { :error => { :value => "Invalid username and password combination, Please Enter your correct megam email", :sticky => false, :nodom_wrap => true } }
     # redirect_to signin_path
    end
  end
  
  

  private

  def collapse_cloud_distrib
    lac = @launched_apps_services.each_with_object(Hash.new{|h,k|h[k]='0'}) do |h,res|
      res[h[:cloud_name].to_sym].succ! if h[:cloud_name] 
    end
    # this is a stupid idea, move it to enum (Rails 4.1 feature)
    lac[:aws] = 0 unless lac[:aws]
    lac[:hp] = 0 unless lac[:hp]
    lac[:profitbricks] = 0 unless lac[:profitbricks]
    lac[:google] = 0 unless lac[:google]
    lac[:podnix] = 0 unless lac[:podnix]
    lac
  end

  def collapse_apps_distrib
    lac = @launched_apps_services.each_with_object(Hash.new{|h,k|h[k]='0'}) do |h,res|
      res[h[:predef_name].to_sym].succ!
    end
    lac
  end

  def show
    redirect_to main_dashboards_path
  end


end

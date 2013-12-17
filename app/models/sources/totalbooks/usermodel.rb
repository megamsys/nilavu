module Sources
  module Totalbooks
    class Usermodel < Sources::Totalbooks::Base
      def get(options = {})
        widget  = Widget.find(options[:wid].to_i)
        dashboard_id = widget.dashboard_id
        dashboard = Dashboard.find(dashboard_id)
        user_id = dashboard.user_id
        c = CloudBook.where(:users_id => user_id).count
        { :value => c }
      end

    end

  end
end

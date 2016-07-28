class NotificationsController < ApplicationController

    before_action :add_authkeys_for_api, only: [:index]

    def index
        user = current_user

        if params[:recent].present?

            limit = (params[:limit] || 15).to_i
            limit = 50 if limit > 50

            notifications = Notification.recent_report(params, limit)
            render json: {notifications: notifications}
        else
            offset = params[:offset].to_i

            offset = 50 unless offset

            notifications = Notification.recent_report(params, offset)

            render json: {
                notifications: notifications,
                load_more_notifications: notifications_path(email: current_user.email, offset: offset + 60)
            }
        end

    end

    def mark_read
        #    Notification.where(user_id: current_user.id).includes(:topic).where(read: false).update_all(read: true)
        #    current_user.saw_notification_id(Notification.recent_report(current_user, 1).max)
        #    current_user.reload
        #    current_user.publish_notifications_state

        render json: success_json
    end
end

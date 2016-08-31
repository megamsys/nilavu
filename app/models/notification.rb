require_dependency 'enum'

class Notification

    def self.recent_report(params, count = nil)
        return unless params

        count ||= 10

        params[:count] = count

        if params[:id]
          notifications =  Api::Events.new.recent_by_id(params)
        else
        notifications =  Api::Events.new.recent(params)
      end


        # notifications = notifications.to_a

        # if notifications.present?
        #    notifications.uniq(&:id).sort do |x,y|
        #        if x.unread? && !y.unread?
        #            -1
        #        elsif y.unread? && !x.unread?
        #          1
        #      else
        #          y.created_at <=> x.created_at
        #      end
        #  end.take(count)
        #  else
        #      []
        #  end
        notifications
    end

    def self.mark_posts_read(user, topic_id, post_numbers)
        #  count = Notification
        #  .where(user_id: user.id,
        #    topic_id: topic_id,
        #    post_number: post_numbers,
        #  read: false)
        #  .update_all("read = 't'")
        #
        #  user.publish_notifications_state if count > 0

        #  count
    end

    def self.interesting_after(min_date)
        #  result =  # get an api call done

        # Remove any duplicates by type and topic
        #  if result.present?
        #    seen = {}
        #    to_remove = Set.new

        #    result.each do |r|
        #      seen[r.notification_type] ||= Set.new
        #      if seen[r.notification_type].include?(r.topic_id)
        #        to_remove << r.id
        #      else
        #        seen[r.notification_type] << r.topic_id
        #      end
        #    end
        #    result.reject! {|r| to_remove.include?(r.id) }
        #  end

        #  result
    end

    # Clean up any notifications the user can no longer see.
    def self.remove_for(user_id, topic_id)
        #  Notification.where(user_id: user_id, topic_id: topic_id).delete_all
    end



end

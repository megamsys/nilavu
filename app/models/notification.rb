require_dependency 'enum'

class Notification


  def self.types
    @types ||= Enum.new(vm_compute_launching: 1,
      cs_compute_launching: 2,
      vm_storage: 3,
    vm_networked: 4)
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

  # Clean up any notifications the user can no longer see. For example, if a topic was previously
  # public then turns private.
  def self.remove_for(user_id, topic_id)
  #  Notification.where(user_id: user_id, topic_id: topic_id).delete_all
  end

  def data_hash
  #  @data_hash ||= begin
  #    return nil if data.blank?

  #    parsed = JSON.parse(data)
  #    return nil if parsed.blank?

  #    parsed.with_indifferent_access
  #  end
  end

  def text_description
    link = block_given? ? yield : ""
    I18n.t("notification_types.#{Notification.types[notification_type]}", data_hash.merge(link: link))
  end

  def url
  #  topic.relative_url(post_number) if topic.present?
  end

  protected

  def refresh_notification_count
  end

end

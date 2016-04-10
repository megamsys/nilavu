# Helps us respond with a topic list from a controller
module CockpitListResponder
=begin
  def respond_with_list(list)
    list.draft_key = Draft::NEW_TOPIC
    list.draft_sequence = DraftSequence.current(current_user, Draft::NEW_TOPIC)
    list.draft = Draft.get(current_user, list.draft_key, list.draft_sequence) if current_user

    respond_to do |format|
      format.html do
        @list = list
        puts "----------------------------------------"
        puts MultiJson.dump(TopicListSerializer.new(list, scope: guardian))
        puts "----------------------------------------"
        store_preloaded(list.preload_key, MultiJson.dump(TopicListSerializer.new(list, scope: guardian)))
        render 'list/list'
        render :json list_json
      end
      format.json do
        render_serialized(list, TopicListSerializer)
      end
    end
  end
=end
end

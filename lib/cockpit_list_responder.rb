# Helps us respond with a topic list from a controller
module CockpitListResponder
    def respond_with_list(list)
        respond_to do |format|
            format.json do
                render json:  {
                    topic_list: {
                        name: 'topics',
                        topics: list
                    }
                }
            end
        end
    end
end

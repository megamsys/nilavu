class Teams

    attr_reader :teams, :teams_by_id

    def initialize()
    end

    def has_team?
        !teams.blank?
    end

    def find_all(params)
        @teams = Api::Organizations.new.list(params)
        @teams_by_id = {}

        @teams.each do |t|
            @teams_by_id[t.id] = build_relevant_team(t, params) if t
        end
    end


    # Retrieve a list of all domains attached to a team.
    def build_relevant_team(team, params)
        Api::Team.new(team).tap do  |t|
            t.find(params)
        end
    end

    def last_used(last_seen=0)
        @teams_by_id.values[last_seen] if @teams_by_id
    end

    def domains_for(team)
      @teams_by_id[team.id].domain
    end

    def to_hash
        h = Hash.new
        if has_team?
            teams.each do |team|
                h[team.name] = domains_for(team).map{|d| d}
              end
        end
      h
    end

end

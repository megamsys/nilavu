require_dependency 'search/grouped_search_results'

class Search
    include MarketplaceGroups

    def self.per_facet
        5
    end

    def self.per_filter
        50
    end

    # Sometimes we want more topics than are returned due to exclusion of dupes. This is the
    # factor of extra results we'll ask for.
    def self.burst_factor
        3
    end

    def self.facets
        %w(virtualmachine container)
    end

    def self.prepare_data(search_data)
        data = search_data.squish
        data.force_encoding("UTF-8")
        data
    end

    def initialize(term, opts=nil)
        @opts = opts || {}
        @search_context = @opts[:search_context]
        @include_blurbs = @opts[:include_blurbs] || false
        @blurb_length = @opts[:blurb_length]
        @limit = Search.per_facet

        if term.present?
            @term = Search.prepare_data(term.to_s)
        end

        if @opts[:type_filter].present?
            @limit = Search.per_filter
        end
        @results = GroupedSearchResults.new(@opts[:type_filter], term, @search_context, @include_blurbs, @blurb_length)
    end

    def self.execute(term, opts=nil)
        self.new(term, opts).execute
    end

    # Query a term
    def execute
        if @term.blank? || @term.length < (@opts[:min_search_term_length] || SiteSetting.min_search_term_length)
            return nil unless @filters.present?
        end      
        find_grouped_results if @results.search_context.present?

        @results
    end

    private


    def find_grouped_results
        if @results.type_filter.present?
            raise Nilavu::InvalidAccess.new("invalid type filter") unless Search.facets.include?(@results.type_filter)
            send("#{@results.type_filter}_search")
        end

        @results
    end

    def virtualmachine_search
        res = @search_context.select { |l|  l[:name].downcase.include?(@term.downcase)}

        res.each do |r|
            @results.add(r)
        end
    end

    # undecided on how to search images in
    # docker hub.
    def container_search
        res = @search_context
        res.each do |r|
            @results.add(r)
        end
    end

end

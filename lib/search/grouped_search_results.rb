class Search

  class GroupedSearchResults

    class TextHelper
      extend ActionView::Helpers::TextHelper
    end

    attr_reader :type_filter,
                :term, :search_context, :include_blurbs,
                :virtualmachines, :containers,
                :more_virtualmachines, :more_containers

    def initialize(type_filter, term, search_context, include_blurbs, blurb_length)
      @type_filter = type_filter
      @term = term
      @search_context = search_context
      @include_blurbs = include_blurbs
      @blurb_length = blurb_length || 200
      @virtualmachines = []
      @containers = []
    end


    def add(object)
      type = @type_filter.to_s.downcase.pluralize

      if !@type_filter.present? && send(type).length == Search.per_facet
        instance_variable_set("@more_#{type}".to_sym, true)
      else
        (send type) << object
      end
    end
  end

end

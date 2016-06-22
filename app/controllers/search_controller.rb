##require_dependency 'search'

class SearchController < ApplicationController
    respond_to :html, :json

    before_action :add_authkeys_for_api, only: [:show]

  def self.valid_context_types
    %w{virtualmachine container}
  end

  def show
    search_args = {
      type_filter: parms[:type],
      guardian: guardian,
      include_blurbs: true,
      blurb_length: 300
    }

    context, type = lookup_search_context
    if context
      search_args[:search_context] = context
      search_args[:type_filter] = type if type
    end

    search = Search.new(params[:q], search_args)
    result = search.execute

    result.find_user_data(guardian) if result

    serializer = serialize_data(result, GroupedSearchResultSerializer, result: result)

    respond_to do |format|
      format.html do
        store_preloaded("search", MultiJson.dump(serializer))
      end
      format.json do
        render_json_dump(serializer)
      end
    end

  end

  def query
    params.require(:term)

    search_args = { }
    search_args[:type_filter] = params[:type_filter]                 if params[:type_filter].present?
    search_args[:include_blurbs] = params[:include_blurbs] == "true" if params[:include_blurbs].present?
    search_args[:search_for_id] = true                               if params[:search_for_id].present?

    context,type = lookup_search_context

    if context
      search_args[:search_context] = context
      search_args[:type_filter] = type if type
    end

    search = Search.new(params[:term], search_args.symbolize_keys)

    result = search.execute

    render_serialized(result, GroupedSearchResultSerializer, result: result)
  end

  protected

  def lookup_search_context

    return if params[:skip_context] == "true"

    search_context = params[:search_context]
    unless search_context
      if (context = params[:context]) && (id = params[:context_id])
        search_context = {type: context, id: id}
      end
    end


    if search_context.present?
      raise Nilavu::InvalidParameters unless SearchController.valid_context_types.include?(search_context[:type])
    #  raise Nilavu::InvalidParameters.new(:search_context) if search_context[:id].blank?

      context_obj = nil
      type_filter = nil

      [context_obj, type_filter]
    end
  end

end

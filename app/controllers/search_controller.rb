
class SearchController < ApplicationController
    respond_to :html, :json

    before_action :add_authkeys_for_api, only: [:query]

    def self.valid_context_types
        %w{virtualmachine container}
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

        out = result.send(type.pluralize)

        render json: { grouped_search_result: out }
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

            type_filter = search_context[:type]
            if type_filter == 'virtualmachine'
                  context_obj = MarketplaceGroups.find_by_group(params,:prepackaged)
            elsif type_filter == 'container'
                context_obj = DockerHub.search(params[:term])
            end

            [context_obj, type_filter]
        end
    end

end

require 'snapshots_finder'
class TopicsController < ApplicationController
    respond_to :html, :json

    before_action :add_authkeys_for_api, only: [:show, :snapshots]

    def show
        @deployed = DeployedRunner.perform_run(params)

        respond_to do |format|
            if @deployed
                format.json { render json: @deployed.to_h }
            else
                format.json { render json: failed_json }
            end
        end
    end

    def snapshots
      @foundsnapshots ||= SnapshotsFinder.new(params).foundsnapshots
      respond_to do |format|
          if @foundsnapshots
              format.json { render json: {
                success: true,
                message: @foundsnapshots,
              } }
          else
              format.json { render json: {
                success: false,
                message: I18n.t('vm_management.snapshots.list_error')
              } }
          end
      end
   end

end

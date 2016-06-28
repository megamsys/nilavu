class BillingsController < ApplicationController
    include LaunchableAssembler
    include LaunchedBiller

    before_action :add_authkeys_for_api, only: [:index, :show]


    def index
        render json: { regions: regions }.merge(bill(params))
    end
end

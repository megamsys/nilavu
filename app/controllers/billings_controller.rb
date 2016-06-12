class BillingsController < ApplicationController
  include LaunchableAssembler
  include LaunchedBiller

    def index
        render json: { regions: regions }.merge(bill)
    end
end

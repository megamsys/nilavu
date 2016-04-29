class LaunchablesController < ApplicationController
  include LaunchableAssembler
  include LaunchablePreparer
  include LaunchableIdentifier

    respond_to :html, :js

    skip_before_filter :check_xhr

    before_action :add_authkeys_for_api, only: [:index]

    # STEP1: assemble the launchable.
    # - prepare billing, region and compute size to launch
    def assemble
        render json: assembled
    end

    # STEP2: prepare  the launchable.
    # - prepare launch type (vm, app), and the exact launch item (bitnami app or custom app, ubuntu)
    def prepare
      #  render json: prepare(params)
    end

    # STEP3: identity  the launchable.
    # - include sshkey
    def identify
      #  render json: identify(params)
    end
end

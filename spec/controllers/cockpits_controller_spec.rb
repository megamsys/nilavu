require 'spec_helper'
include CatalogHelper

RSpec.describe CockpitsController, :controller => true do

  describe "GET index" do
       it 'assemblies_grouped value is assigned' do

         get :index
         expect(assigns(:assemblies_grouped)).to be_success
      end
    end
end

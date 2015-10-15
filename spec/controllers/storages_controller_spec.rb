require 'rails_helper'

RSpec.describe StoragesController, type: :controller do
 it "handles a missing project correctly" do
   get :show, id: "not-here"

   expect(response).to redirect_to (cockpits_path)

   message = "The project you were looking for cloud not be found."
   expect(flash[:alert]).to eq message
 end

end

require 'rails_helper'

describe MarketplacesController do

    describe '.index' do

        let!(:user) { log_in(:bob) }

        context 'when pull the marketplaces data' do
#            it "should return the list" do
#                xhr :get, :index
#                expect(::JSON.parse(response.body)).to be_present
#            end
        end
    end


    describe '.show' do
        before do
            @user = log_in(:bob)
        end

        it 'should return with nothing' do
          xhr :get, :index
        end
    end
end

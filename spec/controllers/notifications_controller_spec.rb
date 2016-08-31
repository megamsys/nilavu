require 'rails_helper'

describe NotificationsController do

  context 'when logged in' do
    let!(:user) { log_in(:bob) }

    it 'should succeed for recent' do
      xhr :get, :index,  recent: true, limit: "12"
      expect(response).to be_success
    end

    it 'should succeed for vm' do
      xhr :get, :index, id: "ASM5280984445650158211", recent: true, limit: "12"
      expect(response).to be_success
    end

    it 'should succeed for empty' do
      xhr :get, :index, id: "ASM8272477442816017500", recent: true, limit: "12"
      expect(response).to be_success
    end

  end
end

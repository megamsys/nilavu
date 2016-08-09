require 'rails_helper'

describe ApplicationController do

  describe 'set_locale' do
    it 'is sets the default locale when the setting not enabled' do
      user = Fabricate(:user)
      log_in_user(user)
      expect(I18n.locale).to eq(:en)
    end
  end

end

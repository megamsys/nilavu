require 'rails_helper'

describe ApplicatioController do

  describe 'set_locale' do
    it 'sets the one the user prefers' do
    #  SiteSetting.stubs(:allow_user_locale).returns(true)

      user = Fabricate(:user, locale: :fr)
      log_in_user(user)
      ApplicatioController.set_locale
      get :show, {topic_id: topic.id}

      expect(I18n.locale).to eq(:fr)
    end

    it 'is sets the default locale when the setting not enabled' do
      user = Fabricate(:user, locale: :fr)
      log_in_user(user)
      ApplicatioController.set_locale
      get :show, {topic_id: topic.id}

      expect(I18n.locale).to eq(:en)
    end
  end

end

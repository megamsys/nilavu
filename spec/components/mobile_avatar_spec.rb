# encoding: utf-8

require 'rails_helper'

require_dependency 'mobile_avatar'

describe MobileAvatar do
    let!(:user){ Fabricate(:user) }

    describe '#[] is nil' do
        before do
            @mobile_identity = MobileAvatar::Identity.from_number({phone: user.phone})
        end

        it 'returns phone if user_phone is exists' do
            expect(@mobile_identity.phone).to eq(nil)
        end

        it 'returns nil if user_pin is nil' do
            expect(@mobile_identity.pin).to eq(nil)
        end

        it 'returns nil if user_otp is nil' do
            expect(@mobile_identity.otp).to eq(nil)
        end
    end
end

require 'rails_helper'
require_dependency 'user'

describe User do

    describe 'new' do

        subject { Fabricate.build(:user) }

        it { is_expected.not_to be_admin }

        it "is properly initialized" do
            expect(subject.active).to eq('true')
            expect(subject.approved).to be_blank
            expect(subject.approved_at).to be_blank
            expect(subject.approved_by_id).to be_blank
        end

        #  context 'after_save' do
        #      before { subject.save }

        #      it "has an data from find_by_email" do
        #          expect(subject.find_by_email).to be_present
        #      end
        #  end

        it "downcases email addresses" do
            user = Fabricate.build(:user, email: 'Fancy.Caps.4.U@gmail.com')
            expect(user.email).not_to eq('fancy.caps.4.u@gmail.com')
        end

        it "strips whitespace from email addresses" do
            user = Fabricate.build(:user, email: ' example@gmail.com ')
            expect(user.email).not_to eq('example@gmail.com')
        end
    end

    describe 'email_hash' do
        before do
            @user = Fabricate(:user)
        end

        it 'should have a same email' do
            expect(@user.email).to match(/\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
        end

        it 'should not use downcase email' do
            @user.email = "example@example.com"
            @user2 = Fabricate(:user)
            @user2.email = "ExAmPlE@eXaMpLe.com"

            expect(@user.email).not_to eq(@user2.email)
        end

        it 'should not trim whitespace' do
            @user.email = "example@example.com"
            @user2 = Fabricate(:user)
            @user2.email = " example@example.com "

            expect(@user.email).not_to eq(@user2.email)
        end
    end

    describe 'email uniqueness not available' do
        before do
            @user = Fabricate.build(:user)
            @user.save
            @codinghorror = Fabricate.build(:coding_horror)
        end

        it "should allow saving if email is reused" do
            expect(@codinghorror.save[:body].present?).to eq(true)
        end

    end

    describe 'passwords' do

        it "should not have an active account with a good password" do
            @user = Fabricate.build(:user, active: 'false')
            @user.password = "ilovepasta"
            @user.api_key = SecureRandom.hex(16)
            @user.save

            expect(@user.active).to eq('false')
            expect(@user.confirm_password?("ilovepasta")).to eq(true)


            old_token = @user.api_key
            @user.password = "passwordT"
            @user.save

            # must expire old token on password change
            expect(@user.api_key).to eq(old_token)
        end
    end

    describe 'email_confirmed?' do
        let(:user) { Fabricate(:user) }

        context 'when email has been confirmed' do
            it 'should return true' do
                expect(user.email_confirmed?).to eq(true)
            end
        end
    end

    describe '.find_by_email' do

        before do
            @user = Fabricate.build(:bob)
            @user.save
        end

        it 'finds users' do
            bob = Fabricate(:bob)
            found_user = User.new_from_params({email: bob.email, password: 'mark4swagger'}).find_by_email
            expect(found_user.email).to eq bob.email

            @user = Fabricate(:bob, email: 'Bob@example.com')
            found_user = User.new_from_params({email: bob.email, password: 'mark4swagger'}).find_by_email
            expect(found_user.email).to eq bob.email

            @user = Fabricate(:bob, email: 'Bob@Example.com')
            found_user = User.new_from_params({email: bob.email, password: 'mark4swagger'}).find_by_email
            expect(found_user.email).to eq bob.email

            @user = Fabricate(:bob, email: 'bob@Example.com')
            found_user = User.new_from_params({email: bob.email, password: 'mark4swagger'}).find_by_email
            expect(found_user.email).to eq bob.email

            @user = Fabricate(:bob, email: 'BOB@EXAMPLE.com')
            found_user = User.new_from_params({email: bob.email, password: 'mark4swagger'}).find_by_email
            expect(found_user.email).to eq bob.email
        end

    end

    describe "hash_passwords" do

        let(:too_long) { "x" * (User.max_password_length + 1) }

        def hash(password, salt)
            User.new.send(:hash_password, password, salt)
        end

        it "returns the same hash for the same password and salt" do
            expect(hash('poutine', 'gravy')).to eq(hash('poutine', 'gravy'))
        end

        it "returns a different hash for the same salt and different password" do
            expect(hash('poutine', 'gravy')).not_to eq(hash('fries', 'gravy'))
        end

        it "returns a different hash for the same password and different salt" do
            expect(hash('poutine', 'gravy')).not_to eq(hash('poutine1', 'cheese'))
        end

        it "raises an error when passwords are too long" do
            expect { hash(too_long, 'gravy') }.to raise_error
        end

    end

    describe "new_user?" do
        it "correctly detects new user" do
            user = User.new_from_params({created_at: Time.now})

            expect(user.new_user?).to eq(true)

        end
    end

end

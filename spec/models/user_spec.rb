require 'rails_helper'
require_dependency 'user'

describe User do

  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :email }

  describe '#count_by_signup_date' do
    before(:each) do
      User.destroy_all
      Timecop.freeze
      Fabricate(:user)
      Fabricate(:user, created_at: 1.day.ago)
      Fabricate(:user, created_at: 1.day.ago)
      Fabricate(:user, created_at: 2.days.ago)
      Fabricate(:user, created_at: 4.days.ago)
    end
    after(:each) { Timecop.return }
    let(:signups_by_day) { {1.day.ago.to_date => 2, 2.days.ago.to_date => 1, Time.now.utc.to_date => 1} }

    it 'collect closed interval signups' do
      expect(User.count_by_signup_date(2.days.ago, Time.now)).to include(signups_by_day)
      expect(User.count_by_signup_date(2.days.ago, Time.now)).not_to include({4.days.ago.to_date => 1})
    end
  end

  describe 'bookmark' do
    before do
      @post = Fabricate(:post)
    end

    it "creates a bookmark with the true parameter" do
      expect {
        PostAction.act(@post.user, @post, PostActionType.types[:bookmark])
      }.to change(PostAction, :count).by(1)
    end

    describe 'when removing a bookmark' do
      before do
        PostAction.act(@post.user, @post, PostActionType.types[:bookmark])
      end

      it 'reduces the bookmark count of the post' do
        active = PostAction.where(deleted_at: nil)
        expect {
          PostAction.remove_act(@post.user, @post, PostActionType.types[:bookmark])
        }.to change(active, :count).by(-1)
      end
    end
  end

  describe 'new' do

    subject { Fabricate.build(:user) }

    it { is_expected.to be_valid }
    it { is_expected.not_to be_admin }
    it { is_expected.not_to be_approved }

    it "is properly initialized" do
      expect(subject.approved_at).to be_blank
      expect(subject.approved_by_id).to be_blank
      expect(subject.email_private_messages).to eq(true)
      expect(subject.email_direct).to eq(true)
    end

    context 'after_save' do
      before { subject.save }

      it "has an email token" do
        expect(subject.email_tokens).to be_present
      end
    end

    it "downcases email addresses" do
      user = Fabricate.build(:user, email: 'Fancy.Caps.4.U@gmail.com')
      user.valid?
      expect(user.email).to eq('fancy.caps.4.u@gmail.com')
    end

    it "strips whitespace from email addresses" do
      user = Fabricate.build(:user, email: ' example@gmail.com ')
      user.valid?
      expect(user.email).to eq('example@gmail.com')
    end
  end

  describe 'email_hash' do
    before do
      @user = Fabricate(:user)
    end

    it 'should have a sane email hash' do
      expect(@user.email_hash).to match(/^[0-9a-f]{32}$/)
    end

    it 'should use downcase email' do
      @user.email = "example@example.com"
      @user2 = Fabricate(:user)
      @user2.email = "ExAmPlE@eXaMpLe.com"

      expect(@user.email_hash).to eq(@user2.email_hash)
    end

    it 'should trim whitespace before hashing' do
      @user.email = "example@example.com"
      @user2 = Fabricate(:user)
      @user2.email = " example@example.com "

      expect(@user.email_hash).to eq(@user2.email_hash)
    end
  end

  describe 'name heuristics' do
    it 'is able to guess a decent name from an email' do
      expect(User.suggest_name('sam.saffron@gmail.com')).to eq('Sam Saffron')
    end
  end

  describe 'email format' do
    def assert_bad(username)
      user = Fabricate.build(:user)
      user.username = username
      expect(user.valid?).to eq(false)
    end

    def assert_good(username)
      user = Fabricate.build(:user)
      user.username = username
      expect(user.valid?).to eq(true)
    end

    it "should be SiteSetting.min_username_length chars or longer" do
      SiteSetting.min_username_length = 5
      assert_bad("abcd")
      assert_good("abcde")
    end

    %w{ first.last
        first first-last
        _name first_last
        mc.hammer_nose
        UPPERCASE
        sgif
    }.each do |username|
      it "allows #{username}" do
        assert_good(username)
      end
    end

    %w{
      traildot.
      has\ space
      double__underscore
      with%symbol
      Exclamation!
      @twitter
      my@email.com
      .tester
      sa$sy
      sam.json
      sam.xml
      sam.html
      sam.htm
      sam.js
      sam.woff
      sam.Png
      sam.gif
    }.each do |username|
      it "disallows #{username}" do
        assert_bad(username)
      end
    end
  end

  describe 'email uniqueness' do
    before do
      @user = Fabricate.build(:user)
      @user.save!
      @codinghorror = Fabricate.build(:coding_horror)
    end

    it "should not allow saving if username is reused" do
       @codinghorror.username = @user.username
       expect(@codinghorror.save).to eq(false)
    end

    it "should not allow saving if username is reused in different casing" do
       @codinghorror.username = @user.username.upcase
       expect(@codinghorror.save).to eq(false)
    end
  end

  context '.username_available?' do
    it "returns true for a username that is available" do
      expect(User.username_available?('BruceWayne')).to eq(true)
    end

    it 'returns false when a username is taken' do
      expect(User.username_available?(Fabricate(:user).username)).to eq(false)
    end
  end

  describe 'email_validator' do
    it 'should allow good emails' do
      user = Fabricate.build(:user, email: 'good@gmail.com')
      expect(user).to be_valid
    end

    it 'should reject some emails based on the email_domains_blacklist site setting' do
      SiteSetting.stubs(:email_domains_blacklist).returns('mailinator.com')
      expect(Fabricate.build(:user, email: 'notgood@mailinator.com')).not_to be_valid
      expect(Fabricate.build(:user, email: 'mailinator@gmail.com')).to be_valid
    end

    it 'should reject some emails based on the email_domains_blacklist site setting' do
      SiteSetting.stubs(:email_domains_blacklist).returns('mailinator.com|trashmail.net')
      expect(Fabricate.build(:user, email: 'notgood@mailinator.com')).not_to be_valid
      expect(Fabricate.build(:user, email: 'notgood@trashmail.net')).not_to be_valid
      expect(Fabricate.build(:user, email: 'mailinator.com@gmail.com')).to be_valid
    end

    it 'should not reject partial matches' do
      SiteSetting.stubs(:email_domains_blacklist).returns('mail.com')
      expect(Fabricate.build(:user, email: 'mailinator@gmail.com')).to be_valid
    end

    it 'should reject some emails based on the email_domains_blacklist site setting ignoring case' do
      SiteSetting.stubs(:email_domains_blacklist).returns('trashmail.net')
      expect(Fabricate.build(:user, email: 'notgood@TRASHMAIL.NET')).not_to be_valid
    end

    it 'should reject emails based on the email_domains_blacklist site setting matching subdomain' do
      SiteSetting.stubs(:email_domains_blacklist).returns('domain.com')
      expect(Fabricate.build(:user, email: 'notgood@sub.domain.com')).not_to be_valid
    end

    it 'blacklist should not reject developer emails' do
      Rails.configuration.stubs(:developer_emails).returns('developer@megam.io.org')
      SiteSetting.stubs(:email_domains_blacklist).returns('megam.io')
      expect(Fabricate.build(:user, email: 'developer@megam.io')).to be_valid
    end

    it 'should not interpret a period as a wildcard' do
      SiteSetting.stubs(:email_domains_blacklist).returns('trashmail.net')
      expect(Fabricate.build(:user, email: 'good@trashmailinet.com')).to be_valid
    end

    it 'should not be used to validate existing records' do
      u = Fabricate(:user, email: 'in_before_blacklisted@fakemail.com')
      SiteSetting.stubs(:email_domains_blacklist).returns('fakemail.com')
      expect(u).to be_valid
    end

    it 'should be used when email is being changed' do
      SiteSetting.stubs(:email_domains_blacklist).returns('mailinator.com')
      u = Fabricate(:user, email: 'good@gmail.com')
      u.email = 'nope@mailinator.com'
      expect(u).not_to be_valid
    end

    it 'whitelist should reject some emails based on the email_domains_whitelist site setting' do
      SiteSetting.stubs(:email_domains_whitelist).returns('vaynermedia.com')
      expect(Fabricate.build(:user, email: 'notgood@mailinator.com')).not_to be_valid
      expect(Fabricate.build(:user, email: 'sbauch@vaynermedia.com')).to be_valid
    end

    it 'should reject some emails based on the email_domains_whitelist site setting when whitelisting multiple domains' do
      SiteSetting.stubs(:email_domains_whitelist).returns('vaynermedia.com|gmail.com')
      expect(Fabricate.build(:user, email: 'notgood@mailinator.com')).not_to be_valid
      expect(Fabricate.build(:user, email: 'notgood@trashmail.net')).not_to be_valid
      expect(Fabricate.build(:user, email: 'mailinator.com@gmail.com')).to be_valid
      expect(Fabricate.build(:user, email: 'mailinator.com@vaynermedia.com')).to be_valid
    end

    it 'should accept some emails based on the email_domains_whitelist site setting ignoring case' do
      SiteSetting.stubs(:email_domains_whitelist).returns('vaynermedia.com')
      expect(Fabricate.build(:user, email: 'good@VAYNERMEDIA.COM')).to be_valid
    end

    it 'whitelist should accept developer emails' do
      Rails.configuration.stubs(:developer_emails).returns('developer@megam.io')
      SiteSetting.stubs(:email_domains_whitelist).returns('awesome.org')
      expect(Fabricate.build(:user, email: 'developer@megam.io')).to be_valid
    end

    it 'email whitelist should not be used to validate existing records' do
      u = Fabricate(:user, email: 'in_before_whitelisted@fakemail.com')
      SiteSetting.stubs(:email_domains_blacklist).returns('vaynermedia.com')
      expect(u).to be_valid
    end

    it 'email whitelist should be used when email is being changed' do
      SiteSetting.stubs(:email_domains_whitelist).returns('vaynermedia.com')
      u = Fabricate(:user, email: 'good@vaynermedia.com')
      u.email = 'nope@mailinator.com'
      expect(u).not_to be_valid
    end
  end

  describe 'passwords' do

    it "should not have an active account with a good password" do
      @user = Fabricate.build(:user, active: false)
      @user.password = "ilovepasta"
      @user.save!

      @user.auth_token = SecureRandom.hex(16)
      @user.save!

      expect(@user.active).to eq(false)
      expect(@user.confirm_password?("ilovepasta")).to eq(true)


      email_token = @user.email_tokens.create(email: 'pasta@delicious.com')

      old_token = @user.auth_token
      @user.password = "passwordT"
      @user.save!

      # must expire old token on password change
      expect(@user.auth_token).to_not eq(old_token)

      email_token.reload
      expect(email_token.expired).to eq(true)
    end
  end

  describe 'email_confirmed?' do
    let(:user) { Fabricate(:user) }

    context 'when email has not been confirmed yet' do
      it 'should return false' do
        expect(user.email_confirmed?).to eq(false)
      end
    end

    context 'when email has been confirmed' do
      it 'should return true' do
        token = user.email_tokens.find_by(email: user.email)
        EmailToken.confirm(token.token)
        expect(user.email_confirmed?).to eq(true)
      end
    end

    context 'when user has no email tokens for some reason' do
      it 'should return false' do
        user.email_tokens.each {|t| t.destroy}
        user.reload
        expect(user.email_confirmed?).to eq(true)
      end
    end
  end

  describe '.find_by_username_or_email' do
    it 'finds users' do
      bob = Fabricate(:user, username: 'bob', email: 'bob@example.com')
      found_user = User.find_by_username_or_email('Bob')
      expect(found_user).to eq bob

      found_user = User.find_by_username_or_email('bob@Example.com')
      expect(found_user).to eq bob

      found_user = User.find_by_username_or_email('Bob@Example.com')
      expect(found_user).to eq bob

      found_user = User.find_by_username_or_email('bob1')
      expect(found_user).to be_nil

      found_user = User.find_by_email('bob@Example.com')
      expect(found_user).to eq bob

      found_user = User.find_by_email('BOB@Example.com')
      expect(found_user).to eq bob

      found_user = User.find_by_email('bob')
      expect(found_user).to be_nil

      found_user = User.find_by_username('bOb')
      expect(found_user).to eq bob
    end

  end

  describe 'api keys' do
    let(:admin) { Fabricate(:admin) }
    let(:other_admin) { Fabricate(:admin) }
    let(:user) { Fabricate(:user) }

    describe '.generate_api_key' do

      it "generates an api key when none exists, and regenerates when it does" do
        expect(user.api_key).to be_blank

        # Generate a key
        api_key = user.generate_api_key(admin)
        expect(api_key.user).to eq(user)
        expect(api_key.key).to be_present
        expect(api_key.created_by).to eq(admin)

        user.reload
        expect(user.api_key).to eq(api_key)

        # Regenerate a key. Keeps the same record, updates the key
        new_key = user.generate_api_key(other_admin)
        expect(new_key.id).to eq(api_key.id)
        expect(new_key.key).to_not eq(api_key.key)
        expect(new_key.created_by).to eq(other_admin)
      end

    end

    describe '.revoke_api_key' do

      it "revokes an api key when exists" do
        expect(user.api_key).to be_blank

        # Revoke nothing does nothing
        user.revoke_api_key
        user.reload
        expect(user.api_key).to be_blank

        # When a key is present it is removed
        user.generate_api_key(admin)
        user.reload
        user.revoke_api_key
        user.reload
        expect(user.api_key).to be_blank
      end

    end

  end

  describe "#find_email" do

    let(:user) { Fabricate(:user, email: "bob@example.com") }

    context "when email is exists in the email logs" do
      before { user.stubs(:last_sent_email_address).returns("bob@lastemail.com") }

      it "returns email from the logs" do
        expect(user.find_email).to eq("bob@lastemail.com")
      end
    end

    context "when email does not exist in the email logs" do
      before { user.stubs(:last_sent_email_address).returns(nil) }

      it "fetches the user's email" do
        expect(user.find_email).to eq(user.email)
      end
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
      expect(hash('poutine', 'gravy')).not_to eq(hash('poutine', 'cheese'))
    end

    it "raises an error when passwords are too long" do
      expect { hash(too_long, 'gravy') }.to raise_error
    end

  end

  describe "new_user?" do
    it "correctly detects new user" do
      user = User.new(created_at: Time.now, trust_level: TrustLevel[0])

      expect(user.new_user?).to eq(true)

      user.trust_level = TrustLevel[1]

      expect(user.new_user?).to eq(true)

      user.trust_level = TrustLevel[2]

      expect(user.new_user?).to eq(false)

      user.trust_level = TrustLevel[0]
      user.moderator = true

      expect(user.new_user?).to eq(false)
    end
  end

end

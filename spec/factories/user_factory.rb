FactoryGirl.define do
  factory :user, :class => 'User' do
    email "test1@megam.com"
    password 'speed'
  end
end

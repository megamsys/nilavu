FactoryGirl.define do
  factory :accounts do
    #sequence(:email) {|n| "user#{n}@example.com" }
    email "test@three.com"
    password 'speed'
  end
end

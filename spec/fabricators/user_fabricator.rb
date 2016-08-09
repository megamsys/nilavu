Fabricator(:user) do
  first_name 'Bruce'
  last_name  'Wayne'
  email { sequence(:email) { |i| "bruce#{i}@wayne.com" } }
  password 'myawesomepassword'
  active 'true'
end

Fabricator(:coding_horror, from: :user) do
  first_name 'Coding Horror'
  email 'jeff@somewhere.com'
  password 'myawesomepassword'
  team  { Api::Team.new(Object.any_instance.stubs(id: 'ORG6135451166522419881', name: 'megambox.com', created_at: Time.now)) }
end

Fabricator(:evil_trout, from: :user) do
  first_name 'Evil Trout'
  email 'eviltrout@somewhere.com'
  password 'imafish'
end

Fabricator(:walter_white, from: :user) do
  first_name 'Walter White'
  email 'wwhite@bluemeth.com'
  password 'letscook'
end

Fabricator(:newuser, from: :user) do
  first_name 'Newbie'
  last_name 'NewPerson'
  email 'newbie@new.com'
end

Fabricator(:bob, from: :user) do
  first_name 'Bob Lee'
  last_name 'Swagger'
  email 'boblee@shooter.com'
  password 'mark4swagger'
  api_key 'scroogeduck#4'
end

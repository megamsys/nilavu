Fabricator(:user) do
  firstname 'Bruce'
  lastname  'Wayne'
  email { sequence(:email) { |i| "bruce#{i}@wayne.com" } }
  password 'myawesomepassword'
  active true
end

Fabricator(:coding_horror, from: :user) do
  firstname 'Coding Horror'
  email 'jeff@somewhere.com'
  password 'mymoreawesomepassword'
end

Fabricator(:evil_trout, from: :user) do
  firstname 'Evil Trout'
  email 'eviltrout@somewhere.com'
  password 'imafish'
end

Fabricator(:walter_white, from: :user) do
  firstname 'Walter White'
  email 'wwhite@bluemeth.com'
  password 'letscook'
end

Fabricator(:newuser, from: :user) do
  firstname 'Newbie'
  lastname 'NewPerson'
  email 'newbie@new.com'
end

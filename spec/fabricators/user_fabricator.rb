Fabricator(:user) do
  fullname { Faker::Name.name }
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end

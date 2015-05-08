Fabricator(:user) do
  fullname { Faker::Name.name }
  email { Faker::Internet.email }
  password { 'pwd' }
end

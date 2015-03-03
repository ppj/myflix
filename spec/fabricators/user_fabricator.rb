Fabricator(:user) do
  fullname { 'P J' }
  email { Faker::Internet.email }
  password { 'pwd' }
end

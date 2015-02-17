Fabricator(:video) do
  title { Faker::Lorem.words 2 }
  description { Faker::Lorem.words 5 }
end

Fabricator(:review) do
  body { Faker::Lorem.paragraph(3) }
  rating { Array(1..5).sample }
end

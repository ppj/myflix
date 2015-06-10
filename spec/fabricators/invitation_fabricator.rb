Fabricator(:invitation) do
  invitee_name { Faker::Name.name }
  invitee_email { Faker::Internet.email }
  message { Faker::Lorem.paragraph(2) }
  inviter { Fabricate :user }
end

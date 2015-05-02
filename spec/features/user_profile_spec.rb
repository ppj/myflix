require 'spec_helper'

feature "View User Profile" do
  scenario "view any user's profile" do
    bob = Fabricate :user
    monk = Fabricate :video
    queue_item = bob.queue_items.create(video: monk)
    review = bob.reviews.create(video: monk, rating: 3, body: "This is a sample review!")
    visit user_path(bob)
    expect_to_find "#{bob.fullname}'s video collection (1)"
    expect_to_find monk.title
    expect_to_find monk.category.name
    expect_to_find "#{bob.fullname}'s Reviews (1)"
    expect_to_find "Rating: #{review.rating} / 5"
    expect_to_find review.body
  end
end

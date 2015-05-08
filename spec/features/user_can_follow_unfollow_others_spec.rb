require 'spec_helper'

feature "Social networking feature" do
  scenario "user can follow, unfollow another user" do
    nat = Fabricate :user
    category = Fabricate :category
    video1 = category.videos.create Fabricate.attributes_for(:video)
    review = Fabricate :review, creator: nat, video: video1

    sign_in_user
    visit home_path
    click_video_image_on_home_page video1
    click_on nat.fullname
    click_on "Follow"

    click_on "People"
    expect_to_find nat.fullname

    unfollow nat
    expect_to_not_find "//tr[contains(., '#{nat.fullname}')]", :xpath
  end
end

def unfollow(user)
  within(:xpath, "//tr[contains(., '#{user.fullname}')]") do
    find("a[data-method='delete']").click
  end
end

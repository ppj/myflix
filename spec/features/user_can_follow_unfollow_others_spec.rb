require 'spec_helper'

feature "Social networking feature" do
  scenario "user can follow, unfollow another user" do
    bob = Fabricate :user
    nat = Fabricate :user
    category = Fabricate :category
    video1 = category.videos.create Fabricate.attributes_for(:video)
    review = Fabricate :review, creator: nat, video: video1

    sign_in_user bob
    visit home_path
    click_video_image video1
    click_on nat.fullname
    click_on "Follow"

    click_on "People"
    expect_to_find nat.fullname

    click_unfollow_icon nat
    expect_to_not_find "//tr[contains(., '#{nat.fullname}')]", "xpath"
  end
end

def click_video_image(video)
  find("a[href='/videos/#{video.id}']").click
end

def click_unfollow_icon(user)
  within(:xpath, "//tr[contains(., '#{user.fullname}')]") do
    find("a[data-method='delete']").click
  end
end

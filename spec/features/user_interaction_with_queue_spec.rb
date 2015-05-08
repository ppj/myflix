require 'spec_helper'

feature "User Interaction With Queue" do
  scenario "user adds videos to queue and reorders them" do
    bob = Fabricate(:user)
    category = Fabricate(:category)
    video1 = category.videos.create(Fabricate.attributes_for(:video))
    video2 = category.videos.create(Fabricate.attributes_for(:video))
    video3 = category.videos.create(Fabricate.attributes_for(:video))

    sign_in_user bob

    add_video_to_queue video1
    expect_to_find video1.title

    click_link video1.title
    expect_to_find video1.title
    expect_to_not_find "+ My Queue"

    add_video_to_queue video2
    add_video_to_queue video3

    fill_in_video_position video1, 5
    fill_in_video_position video2, 2
    fill_in_video_position video3, 3

    update_queue

    expect_video_position video1, 3
    expect_video_position video2, 1
    expect_video_position video3, 2
  end
end

def add_video_to_queue(video)
  visit home_path
  find("a[href='/videos/#{video.id}']").click
  click_link "+ My Queue"
end

def fill_in_video_position(video, position)
  within(:xpath, "//tr[contains(., '#{video.title}')]") do
    fill_in "queue_items[][position]", with: position
  end
end

def expect_video_position(video, position)
  expect(find(:xpath, "//tr[contains(., '#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
end

def update_queue
  click_on "Update Instant Queue"
end

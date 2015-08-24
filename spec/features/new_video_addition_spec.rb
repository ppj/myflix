require 'spec_helper'

feature "New Video" do
  scenario "with existing credentials" do
    admin = Fabricate(:admin)
    sign_in_user admin
    admin_adds_new_video(video_url: "http://wwww.fake.url/my_video.mp4")
    sign_out_user

    sign_in_user
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://wwww.fake.url/my_video.mp4']")
  end
end

def admin_adds_new_video(video_url:)
  category = Fabricate(:category)
  visit new_admin_video_path
  fill_in "Title", with: "New Vid"
  select category.name, from: "Category"
  fill_in "Description", with: "some hilarious description"
  attach_file "Large cover", "public/tmp/monk_large.jpg"
  attach_file "Small cover", "public/tmp/monk.jpg"
  fill_in "Video url", with: video_url
  click_on "Add Video"
end


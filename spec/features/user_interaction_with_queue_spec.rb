require 'spec_helper'

feature "User Interaction With Queue" do

  scenario "user adds videos to queue and reorders them" do
    bob = Fabricate(:user)
    category = Fabricate(:category)
    video = category.videos.create(Fabricate.attributes_for(:video))
    sign_in_user bob

    find("a[href='#{video_path(video)}']").click
    click_link "+ My Queue"
    expect(page).to have_content(video.title)

    click_link video.title
    expect(page).to have_content(video.title)
    expect(page).to have_no_content("+ My Queue")

    video1 = Fabricate(:video)
    visit video_path(video1)
    click_link "+ My Queue"

    video2 = Fabricate(:video)
    visit video_path(video2)
    click_link "+ My Queue"

    fill_in "video_#{video.id}",  with: 5
    fill_in "video_#{video1.id}", with: 2
    fill_in "video_#{video2.id}", with: 3

    click_on "Update Instant Queue"

    expect(find("#video_#{video.id}").value).to eq("3")
    expect(find("#video_#{video1.id}").value).to eq("1")
    expect(find("#video_#{video2.id}").value).to eq("2")
  end
end


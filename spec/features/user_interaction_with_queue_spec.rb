require 'spec_helper'

feature "User Interaction With Queue" do

  scenario "user adds videos to queue and reorders them" do
    bob = Fabricate(:user)
    category = Fabricate(:category)
    video1 = category.videos.create(Fabricate.attributes_for(:video))
    sign_in_user bob

    find("a[href='/videos/#{video1.id}']").click
    click_link "+ My Queue"
    expect(page).to have_content(video1.title)

    click_link video1.title
    expect(page).to have_content(video1.title)
    expect(page).to have_no_content("+ My Queue")

    video2 = category.videos.create(Fabricate.attributes_for(:video))
    visit home_path
    find("a[href='/videos/#{video2.id}']").click
    click_link "+ My Queue"

    video3 = category.videos.create(Fabricate.attributes_for(:video))
    visit home_path
    find("a[href='/videos/#{video3.id}']").click
    click_link "+ My Queue"

    find("input[data-video-id='#{video1.id}']").set(5)
    find("input[data-video-id='#{video2.id}']").set(4)
    find("input[data-video-id='#{video3.id}']").set(2)
    click_on "Update Instant Queue"

    expect(find("input[data-video-id='#{video1.id}']").value).to eq("3")
    expect(find("input[data-video-id='#{video2.id}']").value).to eq("2")
    expect(find("input[data-video-id='#{video3.id}']").value).to eq("1")
  end
end


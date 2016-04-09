require 'spec_helper'

feature "User interacts with advanced search", :elasticsearch do

  background do
    Fabricate(:video, title: "Star Wars: Episode 1")
    Fabricate(:video, title: "Star Wars: Episode 2")
    Fabricate(:video, title: "Star Trek")
    Fabricate(:video, title: "Bride Wars", description: "some wedding movie!")
    refresh_index
    sign_in_user
    click_on "Advanced Search"
  end

  scenario "user searches with title" do
    within(".advanced_search") do
      fill_in "query", with: "Star Wars"
      click_button "Search"
    end

    expect_to_find("2 videos found")
    expect_to_find("Star Wars: Episode 1")
    expect_to_find("Star Wars: Episode 2")
    expect_to_not_find("Star Trek")
  end

  scenario "user searches with title and description" do
    within(".advanced_search") do
      fill_in "query", with: "wedding movie"
      click_button "Search"
    end
    expect_to_find("Bride Wars")
    expect_to_not_find("Star")
  end
end

def refresh_index
  Video.import
  Video.__elasticsearch__.refresh_index!
end

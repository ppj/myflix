require 'spec_helper'

feature "User interacts with advanced search", :elasticsearch do

  background do
    star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
    star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
    star_trek = Fabricate(:video, title: "Star Trek")
    Fabricate(:video, title: "Bride Wars", description: "some wedding movie!")

    Fabricate(:review, video: star_wars_1, rating: 5, body: "awesome movie!!!")
    Fabricate(:review, video: star_wars_2, rating: 3)
    Fabricate(:review, video: star_trek,  rating: 4)
    Fabricate(:review, video: star_trek,  rating: 5)

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

  scenario "user searches with title, description and review" do
    within(".advanced_search") do
      fill_in "query", with: "awesome movie"
      check "Include Reviews"
      click_button "Search"
    end
    expect_to_find "Star Wars: Episode 1"
    expect_to_not_find "Star Wars: Episode 2"
  end

  scenario "user filters search results with average rating" do
    within(".advanced_search") do
      fill_in "query", with: "Star"
      check "Include Reviews"
      select "4.4", from: "rating_from"
      select "4.6", from: "rating_to"

      click_button "Search"
    end
    expect_to_find "Star Trek"
    expect_to_not_find "Star Wars: Episode 1"
    expect_to_not_find "Star Wars: Episode 2"
  end
end

def refresh_index
  Video.import
  Video.__elasticsearch__.refresh_index!
end

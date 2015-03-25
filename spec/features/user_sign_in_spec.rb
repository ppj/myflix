require 'spec_helper'

feature "User Signs In" do
  background do
    Fabricate(:user, email: "user@sample.com", password: "pwd")
  end

  scenario "with existing credentials" do
    visit root_path
    click_on "Sign In"
    fill_in "Email Address", with: "user@sample.com"
    fill_in "Password", with: "pwd"
    click_button "Sign in"
    expect(page).to have_content "You have successfully logged in."
  end
end

require 'spec_helper'

feature "User Signs In" do
  given(:bob) { Fabricate(:user) }

  scenario "with existing credentials" do
    visit root_path
    click_on "Sign In"
    fill_in "Email Address", with: bob.email
    fill_in "Password", with: bob.password
    click_button "Sign in"
    expect(page).to have_content "You have successfully logged in."
    expect(page).to have_content bob.fullname
  end
end

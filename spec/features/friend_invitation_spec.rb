require 'spec_helper'

feature "friend invitation" do
  scenario "user can invite a friend to join myflix" do
    jane = Fabricate :user
    sign_in_user jane
    visit invite_path

    fill_in "Friend's Name", with: "Joe Doe"
    fill_in "Friend's Email Address", with: "joe@example.com"
    click_on "Send Invitation"

    open_email "joe@example.com"
    current_email.click_link "Click here to join MyFlix."

    fill_in "Password", with: "friend_password"
    click_on "Sign Up"

    fill_in "Email Address", with: "joe@example.com"
    fill_in "Password", with: "friend_password"
    click_on "Sign in"
    expect_to_find "Welcome, Joe Doe"

    click_on "People"
    expect_to_find jane.fullname
  end
end

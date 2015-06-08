require 'spec_helper'

feature "friend invitation" do
  scenario "user can invite a friend to join myflix" do
    jane = Fabricate :user
    sign_in_user jane
    visit invite_path

    fill_in "Friend's Name", with: "Joe"
    fill_in "Friend's Email Address", with: "joe@example.com"
    click_on "Send Invitation"

    open_email "joe@example.com"
    current_email.click_link "join MyFlix"

    fill_in "Password", with: "friend_password"
    fill_in "Full Name", with: "Joe Doe"
    click_on "Sign Up"
    expect_to_find "Hi Joe Doe"

    click_on "People"
    expect_to_find jane.fullname
  end
end

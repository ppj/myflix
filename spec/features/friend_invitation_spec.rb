require 'spec_helper'

feature "friend invitation" do
  scenario "user can invite a friend to join myflix" do
    jane = Fabricate :user
    sign_in_user jane
    click_on "Welcome, #{jane.fullname}"
    click_on "Send Invite"

    fill_in "Friend's Name", with: "Joe Doe"
    fill_in "Friend's Email Address", with: "joe@example.com"
    fill_in "Invitation Message", with: "Join MyFlix and enjoy!"
    click_on "Send Invitation"

    sign_out_user

    open_email "joe@example.com"
    current_email.click_link "Click here to accept the invitation."

    fill_in "Password", with: "friend_password"
    click_on "Sign Up"

    fill_in "Email Address", with: "joe@example.com"
    fill_in "Password", with: "friend_password"
    click_on "Sign in"
    expect_to_find "Welcome, Joe Doe"

    click_on "People"
    expect_to_find jane.fullname

    sign_out_user

    sign_in_user jane
    click_on "People"
    expect_to_find "Joe Doe"

    clear_emails
  end
end

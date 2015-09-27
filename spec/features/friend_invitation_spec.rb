require 'spec_helper'

feature "friend invitation" do
  scenario "user can invite a friend to join myflix", js: true do
    jane = Fabricate :user
    sign_in_user jane

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    friend_should_follow(jane)
    inviter_should_follow_friend(jane)

    clear_emails
  end
end

def invite_a_friend
  visit new_invitation_path
  fill_in "Friend's Name", with: "Joe Doe"
  fill_in "Friend's Email Address", with: "joe@example.com"
  fill_in "Invitation Message", with: "Join MyFlix and enjoy!"
  click_on "Send Invitation"
  sign_out_user
end

def friend_accepts_invitation
  open_email "joe@example.com"
  current_email.click_link "Click here to accept the invitation."
  fill_in "Password", with: "friend_password"
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  click_on "Sign Up"
end

def friend_signs_in
  fill_in "Email Address", with: "joe@example.com"
  fill_in "Password", with: "friend_password"
  click_on "Sign in"
end

def friend_should_follow(inviter)
  click_on "People"
  expect_to_find inviter.fullname
  sign_out_user
end

def inviter_should_follow_friend(inviter)
  sign_in_user inviter
  click_on "People"
  expect_to_find "Joe Doe"
end

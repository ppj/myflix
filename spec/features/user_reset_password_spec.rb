require 'spec_helper'

feature "password reset" do
  given(:bob) { Fabricate :user, password: "old_pwd" }

  scenario "user can reset forgotten password" do
    clear_emails
    visit sign_in_path
    click_link "Don't Remember Your Password?"

    fill_in "Email Address", with: bob.email
    click_on "Send Email"
    open_email bob.email
    current_email.click_link "click here"

    fill_in "New Password", with: "new_pwd"
    click_on "Reset Password"

    fill_in "Email Address", with: bob.email
    fill_in "Password", with: "new_pwd"
    click_on "Sign in"
    expect_to_find "Welcome, #{bob.fullname}"
  end
end

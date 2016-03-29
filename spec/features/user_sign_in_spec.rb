require 'spec_helper'

feature "User Signs In" do
  scenario "with existing credentials" do
    bob = Fabricate(:user)
    sign_in_user bob
    expect_to_find "You have successfully logged in."
    expect_to_find bob.fullname
  end

  scenario "when deactivated" do
    bob = Fabricate(:user, active: false)
    sign_in_user bob
    expect_to_not_find bob.fullname
    expect_to_find "Your account has been deactivated. Please contact support."
  end
end

require 'spec_helper'

feature "User Signs In" do
  scenario "with existing credentials" do
    bob = Fabricate(:user)
    sign_in_user bob
    expect_to_find "You have successfully logged in."
    expect_to_find bob.fullname
  end
end

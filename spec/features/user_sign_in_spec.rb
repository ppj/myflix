require 'spec_helper'

feature "User Signs In" do
  scenario "with existing credentials" do
    bob = Fabricate(:user)
    sign_in_user bob
    expect(page).to have_content "You have successfully logged in."
    expect(page).to have_content bob.fullname
  end
end

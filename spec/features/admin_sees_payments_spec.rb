require 'spec_helper'

feature "admin sees payments" do
  background do
    alice = Fabricate(:user, fullname: "Alice Doe", email: "alice@doe.com")
    Fabricate(:payment,
              user: alice,
              amount: 999,
              reference_id: "payment_ref_id")
  end

  scenario "admin can see all payments" do
    sign_in_user(Fabricate :admin)
    visit admin_payments_path
    expect(page).to have_content "alice@doe.com"
    expect(page).to have_content "Alice Doe"
    expect(page).to have_content "payment_ref_id"
    expect(page).to have_content "$9.99"
  end

  scenario "non-admin user cannot see any payments" do
    sign_in_user
    visit admin_payments_path
    expect(page).to_not have_content "alice@doe.com"
    expect(page).to_not have_content "Alice Doe"
    expect(page).to_not have_content "payment_ref_id"
    expect(page).to_not have_content "$9.99"
    expect(page).to have_content "You are not authorized to do that."
  end
end

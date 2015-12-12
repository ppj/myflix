require 'spec_helper'

feature "User Sign Up", js: true, vcr: true do
  background do
    visit register_path
  end

  scenario "with valid personal info and credit card" do
    enter_valid_personal_info
    submit_with_valid_card

    expect(page).to have_content "You have successfully registered. You can sign in now!"
  end

  scenario "with valid personal info but invalid credit card" do
    enter_valid_personal_info
    submit_with_expired_card

    expect(page).to have_content "Your card has expired"
  end

  scenario "with valid personal info but declined credit card" do
    enter_valid_personal_info
    submit_with_declined_card

    expect(page).to have_content "Your card was declined"
  end

  scenario "with invalid personal info but valid credit card" do
    enter_invalid_personal_info
    submit_with_valid_card

    expect(page).to have_content "Please fix the highlighted errors before continuing..."
  end

  scenario "with invalid personal info and credit card" do
    enter_invalid_personal_info
    submit_with_expired_card

    expect(page).to have_content "Please fix the highlighted errors before continuing..."
  end

  scenario "with invalid personal info and declined credit card" do
    enter_invalid_personal_info
    submit_with_declined_card

    expect(page).to have_content "Please fix the highlighted errors before continuing..."
  end
end

def enter_valid_personal_info
  fill_in "Email Address", with: "johny@super.man"
  fill_in "Password", with: "a really obscure password"
  fill_in "Full Name", with: "Rocky Balboa, Jr."
end

def enter_invalid_personal_info
  fill_in "Email Address", with: "johny@super.man"
end

def submit_with_valid_card
  submit_with_card "4242424242424242"
end

def submit_with_expired_card
  submit_with_card "4000000000000069"
end

def submit_with_declined_card
  submit_with_card "4000000000000002"
end

private

def submit_with_card(card_number)
  fill_in "Credit Card Number", with: card_number
  fill_in "Security Code", with: "321"
  select "12 - December", from: "date_month"
  select (Time.now.year+1).to_s, from: "date_year"

  click_on "Sign Up"
end


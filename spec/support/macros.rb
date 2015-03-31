def set_current_user(user = nil)
  user ||= Fabricate(:user)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id])
end

def sign_out_user
  session[:user_id] = nil
end

def sign_in_user(user = nil)
  user ||= Fabricate(:user)
  visit root_path
  click_on "Sign In"
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def expect_to_find(text)
  expect(page).to have_content(text)
end

def expect_to_not_find(text)
  expect(page).to have_no_content(text)
end


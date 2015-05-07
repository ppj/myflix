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

def expect_to_find(target, search_type=:content)
  search_method = "have_" + search_type.to_s
  expect(page).to send(search_method, target)
end

def expect_to_not_find(target, search_type=:content)
  search_method = "have_no_" + search_type.to_s
  expect(page).to send(search_method, target)
end

def click_video_image_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end


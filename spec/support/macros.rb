def sign_in_user
  user = Fabricate(:user)
  session[:user_id] = user.id
  user
end

def sign_out
  session[:user_id] = nil
end

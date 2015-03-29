def set_current_user
  user = Fabricate(:user)
  session[:user_id] = user.id
  user
end

def sign_out_user
  session[:user_id] = nil
end

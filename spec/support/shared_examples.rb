shared_examples "a gatekeeper redirecting an unauthenticated user" do
  it "redirects to the root page"  do
    clear_user_from_session
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples "a gatekeeper redirecting a non-admin user" do
  it "redirects to the home page"  do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
end

shared_examples "tokenable" do
  it "should have a token" do
    expect(object.token).to be_present
  end
end


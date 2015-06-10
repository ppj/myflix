shared_examples "a gatekeeper redirecting an unauthenticated user" do
  it "redirects to the root page"  do
    clear_user_from_session
    action
    expect(response).to redirect_to root_path
  end
end

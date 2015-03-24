shared_examples "a signed out user" do
  it "redirects to root path for an unauthenticated user"  do
    sign_out
    action
    expect(response).to redirect_to root_path
  end
end

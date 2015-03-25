shared_examples "a security guard" do
  it "redirects to the root page"  do
    sign_out_user
    action
    expect(response).to redirect_to root_path
  end
end

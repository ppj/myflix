require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user to a new User" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    it "creates new user given correct credentials" do
      post :create, user: {fullname: 'Sample User', password: 'pwd', email: Faker::Internet.email }
      expect(User.first.fullname).to eq('Sample User')
      expect(User.first.authenticate('pwd')).to be_truthy
    end

    it "redirects to the sign-in path after creating the user" do
      post :create, user: {fullname: Faker::Name.name, password: Faker::Internet.password, email: Faker::Internet.email }
      expect(response).to redirect_to(sign_in_path)
    end

    it "re-renders the registration form if credentials are invalid" do
      post :create, user: {fullname: 'P', password: Faker::Internet.password, email: Faker::Internet.email }
      expect(response).to render_template(:new)
    end
  end
end

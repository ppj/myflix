require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user to a new User" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET new_invited" do
    before { get :new_invited, token: invitation_token }

    context "with valid token" do
      let (:invitation_token) do
        Fabricate(:invitation,
                  invitee_email: "joe@doe.com").token
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets @user to a new User with fullname and email" do
        expect(assigns(:user)).to be_a_new(User)
        expect(assigns(:user).email).to eq('joe@doe.com')
      end
    end

    context "with an invalid token" do
      let(:invitation_token) { "suchInvalidToken" }

      it "shows the expired token page if invitation not found" do
        expect(response).to redirect_to invalid_token_path
      end
    end
  end

  describe "POST create" do
    before do
      expect(UserSignup).to receive(:perform).and_return(user_signup)
      post :create, user: Fabricate.attributes_for(:user)
    end

    context "when a sign up is successful" do
      let(:user_signup) { double(:user_signup, successful?: true) }

      it "redirects to the sign-in page" do
        expect(response).to redirect_to(sign_in_path)
      end

      it "sets a suitable flash success message" do
        expect(flash[:success]).to eq "You have successfully registered. You can sign in now!"
      end
    end

    context "when a sign up fails" do
      let(:user_signup) do
        double(:user_signup,
               successful?: false,
               error_message: "The sign-up failed!")
      end

      it "renders the sign up form again" do
        expect(response).to render_template(:new)
      end

      it "sets a flash error message" do
        expect(flash[:danger]).to eq "The sign-up failed!"
      end
    end
  end

  describe "GET show" do
    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { get :show, id: 2 }
    end

    it "identifies the user using the passed parameter" do
      set_current_user
      jane = Fabricate :user
      get :show, id: jane.id
      expect(assigns(:user)).to eq(jane)
    end
  end
end

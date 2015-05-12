require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user to a new User" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it "creates new user" do
        expect(User.count).to eq(1)
      end

      it "then redirects to the sign-in page" do
        expect(response).to redirect_to(sign_in_path)
      end

      context "welcome email" do
        it "sends out the email" do
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end

        it "sends the email to new user" do
          email_message = ActionMailer::Base.deliveries.last
          user = assigns(:user)
          expect(email_message.to).to eq([user.email])
        end

        it "has the welcome message" do
          email_message = ActionMailer::Base.deliveries.last
          user = assigns(:user)
          expect(email_message.body).to include(user.fullname)
          expect(email_message.body).to include(user.email)
        end
      end
    end

    context "with invalid credentials" do
      before do
        post :create, user: {fullname: 'P', password: 'pwd', email: 'a@b.com'}
      end

      it "sets @user to a new User" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "cannot save the new user" do
        expect(User.count).to eq(0)
      end

      it "re-renders the registration form" do
        expect(response).to render_template(:new)
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

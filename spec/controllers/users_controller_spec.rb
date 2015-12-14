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
    context "with valid personal information" do
      after { ActionMailer::Base.deliveries.clear }

      before do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user)
      end

      context "and valid credit card" do
        let(:charge) do
          double(:charge,
                 successful?: true)
        end

        it "creates new user" do
          expect(User.count).to eq(1)
        end

        it "redirects to the sign-in page" do
          expect(response).to redirect_to(sign_in_path)
        end
      end

      context "but with an invalid credit card" do
        let(:charge) do
          double(:charge,
                 successful?: false,
                error_message: "Your card was declined.")
        end

        it "does not create a new user" do
          expect(User.count).to eq 0
        end

        it "renders the sign up form again" do
          expect(response).to render_template(:new)
        end

        it "sets the flash error message" do
          expect(flash[:danger]).to eq "Your card was declined."
        end
      end
    end

    context "with invalid personal information" do
      before do
        post :create, user: {fullname: 'P',
                             password: 'pwd',
                             email: 'a@b.com'}
      end

      it "sets @user to a new User" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "does not save the new user" do
        expect(User.count).to eq(0)
      end

      it "re-renders the registration form" do
        expect(response).to render_template(:new)
      end

      it "does not attempt to charge the credit card" do
        allow(StripeWrapper::Charge).to receive(:create)
        expect(StripeWrapper::Charge).to_not have_received(:create)
      end

      it "does not send out the welcome email when credentials are not valid" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "welcome email" do
      after { ActionMailer::Base.deliveries.clear }

      before do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user,
                                                     fullname: "Joe Doe",
                                                     email: "joe@doe.com")
      end
      let(:charge) { double(:charge, successful?: true) }

      it "sends out the email to new user when credentials are valid" do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it "sends the email to new user when credentials are valid" do
        email_message = ActionMailer::Base.deliveries.last
        expect(email_message.to).to eq(["joe@doe.com"])
      end

      it "has the welcome message when credentials are valid" do
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Doe")
      end
    end

    context "with invitation" do
      before do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post(:create,
             invitation_token: invitation.token,
             user: {fullname: invitation.invitee_name,
                    email: invitation.invitee_email,
                    password: "newPwd"})
      end
      let(:charge) { double(:charge, successful?: true) }
      let(:invitation) do
        Fabricate(:invitation,
                  invitee_email: 'joe@doe.com',
                  inviter: Fabricate(:user))
      end
      let(:invitee) { User.find_by(email: "joe@doe.com") }

      it "sets the invited user to follow the inviter" do
        expect(invitation.inviter.follows?(invitee)).to be true
      end

      it "sets the inviter to follow the invited user" do
        expect(invitee.follows?(invitation.inviter)).to be true
      end

      it "deletes the invitation token" do
        expect(invitation.reload.token).to be_nil
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

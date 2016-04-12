require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with valid email address" do
      after { ActionMailer::Base.deliveries.clear }

      it "generates a token for the user" do
        bob = Fabricate :user, email: "bob@bob.com"
        bob.update_column(:token, nil)
        post :create, email: "bob@bob.com"
        expect(bob.reload.token).to be_present
      end

      it "sends an email with a link to reset that user's password" do
        bob = Fabricate :user, email: "bob@bob.com"
        post :create, email: "bob@bob.com"
        email_message = ActionMailer::Base.deliveries.last
        expect(email_message).to be_present
        expect(email_message.to).to eq(["bob@bob.com"])
      end

      it "redirects to the password-reset confirmation page" do
        bob = Fabricate :user, email: "bob@bob.com"
        post :create, email: "bob@bob.com"
        expect(response).to redirect_to(confirm_password_reset_path)
      end
    end

    context "with invalid email address" do
      it "redirects to the forgot-password form" do
        post :create, email: 'invalid@email.com'
        expect(response).to redirect_to(forgot_password_path)
      end

      it "shows an error message about the email address" do
        post :create, email: ''
        expect(flash[:danger]).to be_present
      end

      it "does not send an email" do
        expect { post :create, email: 'what@ever.com' }.
          to_not change { ActionMailer::Base.deliveries.count }
      end
    end
  end
end

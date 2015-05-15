require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with valid email address" do
      it "sends an email with a link to reset that user's password" do
        bob = Fabricate :user, email: "bob@bob.com"
        post :create, email: "bob@bob.com"
        email_message = ActionMailer::Base.deliveries.last
        expect(email_message).to be_present
        expect(email_message.to).to eq(["bob@bob.com"])
        ActionMailer::Base.deliveries.clear
      end

      it "renders password-reset confirmation page" do
        bob = Fabricate :user, email: "bob@bob.com"
        post :create, email: "bob@bob.com"
        expect(response).to render_template(:confirm)
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
        ActionMailer::Base.deliveries.clear
        post :create, email: 'what@ever.com'
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

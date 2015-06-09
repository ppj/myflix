require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { post :create }
    end

    it "redirects to the invitation-sent confirmation page" do
      set_current_user
      post :create, name: "John Doe", email: "john@example.com", message: "Check it out!"
      expect(response).to redirect_to home_path
    end

    it "displays a flash message indicating email delivery" do
      set_current_user
      post :create, name: "John Doe", email: "john@example.com", message: "Check it out!"
      expect(flash[:success]).to be_present
    end

    it "sends an invitation email to the invitee" do
      set_current_user
      post :create, name: "John Doe", email: "john@example.com", message: "Check it out!"
      email_message = ActionMailer::Base.deliveries.last
      expect(email_message).to be_present
      expect(email_message.to).to eq(["john@example.com"])
    end
  end
end

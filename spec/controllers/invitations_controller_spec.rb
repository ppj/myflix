require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { get :new }
    end

    it "assigns @invitation to a new record" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end
  end

  describe "POST create" do
    it_behaves_like "a gatekeeper redirecting an unauthenticated user" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      after { ActionMailer::Base.deliveries.clear }

      it "redirects to the new invitation page" do
        set_current_user
        post :create, invitation: {invitee_name: "John Doe", invitee_email: "john@example.com", message: "Check it out!"}
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        set_current_user
        post :create, invitation: {invitee_name: "John Doe", invitee_email: "john@example.com", message: "Check it out!"}
        expect(Invitation.count).to eq(1)
      end

      it "sets the inviter to the current user" do
        set_current_user
        post :create, invitation: {invitee_name: "John Doe", invitee_email: "john@example.com", message: "Check it out!"}
        expect(assigns(:invitation).inviter).to eq(current_user)
      end

      it "displays a flash success message" do
        set_current_user
        post :create, invitation: {invitee_name: "John Doe", invitee_email: "john@example.com", message: "Check it out!"}
        expect(flash[:success]).to be_present
      end

      it "sends an invitation email to the invitee" do
        set_current_user
        post :create, invitation: {invitee_name: "John Doe", invitee_email: "john@example.com", message: "Check it out!"}
        email_message = ActionMailer::Base.deliveries.last
        expect(email_message).to be_present
        expect(email_message.to).to eq(["john@example.com"])
      end
    end

    context "with invalid inputs" do
      it "renders the new invitation page again" do
        set_current_user
        post :create, invitation: {invitee_email: "john@example.com", message: "Check it out!"}
        expect(response).to render_template :new
      end

      it "sets @invitation" do
        set_current_user
        post :create, invitation: {invitee_email: "john@example.com", message: "Check it out!"}
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end

      it "does not create an invitation" do
        set_current_user
        post :create, invitation: {invitee_email: "john@example.com", message: "Check it out!"}
        expect(Invitation.count).to eq(0)
      end

      it "displays a flash error message" do
        set_current_user
        post :create, invitation: {invitee_email: "john@example.com", message: "Check it out!"}
        expect(flash[:danger]).to be_present
      end

      it "does not send the invitation email" do
        set_current_user
        post :create, invitation: {invitee_email: "john@example.com", message: "Check it out!"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

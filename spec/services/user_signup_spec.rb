require 'spec_helper'

describe UserSignup do
  describe ".perform" do
    subject(:perform) do
      described_class.perform(user: user,
                              invitation_token: invitation_token,
                              stripe_token: stripe_token)
    end
    let(:stripe_token) { "garble" }
    let(:invitation_token) { nil }

    context "with valid personal information" do
      let(:user) do
        Fabricate.build(:user,
                        fullname: "Joe Doe",
                        email: 'joe@doe.com')
      end

      before do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
      end

      context "and valid credit card" do
        let(:charge) { double(:charge, successful?: true) }

        after { ActionMailer::Base.deliveries.clear }

        it "creates new user" do
          perform
          expect(User.count).to eq(1)
        end

        it "sends the welcome email to new user" do
          perform
          email_message = ActionMailer::Base.deliveries.last
          expect(ActionMailer::Base.deliveries).to_not be_empty
          expect(email_message.to).to eq(["joe@doe.com"])
        end

        it "addresses the new user in the welcome message" do
          perform
          expect(ActionMailer::Base.deliveries.last.body).to include("Joe Doe")
        end

        context "with invitation" do
          let(:invitation_token) { "invitation_token" }
          let(:invitation) do
            Fabricate(:invitation,
                      invitee_email: 'joe@doe.com',
                      inviter: Fabricate(:user))
          end
          let(:invitee) { User.find_by(email: 'joe@doe.com') }

          before do
            allow(Invitation).to receive(:find_by).with(token: invitation_token).
              and_return(invitation)
            perform
          end

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

      context "but with an invalid credit card" do
        let(:charge) do
          double(:charge,
                 successful?: false,
                 error_message: "Your card was declined.")
        end

        it "does not create a new user" do
          perform
          expect(User.count).to eq 0
        end

        it "sets the error message" do
          expect(perform.error_message).to eq "Your card was declined."
        end
      end
    end

    context "with invalid personal information" do
      let(:user) do
        Fabricate.build(:user, fullname: "Joe Doe", email: nil)
      end

      before do
        allow(StripeWrapper::Charge).to receive(:create)
        perform
      end

      it "does not save the new user" do
        expect(User.count).to eq(0)
      end

      it "does not attempt to charge the credit card" do
        expect(StripeWrapper::Charge).to_not have_received(:create)
      end

      it "does not send out the welcome email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

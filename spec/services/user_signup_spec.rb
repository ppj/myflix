require 'spec_helper'

describe UserSignup do
  describe ".perform" do
    context "with valid personal information" do
      let(:user) do
        Fabricate.build(:user,
                        fullname: "Joe Doe",
                        email: 'joe@doe.com')
      end

      before do
        expect(StripeWrapper::Customer).to receive(:create).with(
          email: "joe@doe.com",
          source: stripe_token,
          description: "MyFlix subscription for joe@doe.com"
        ).and_return(stripe_response)
      end
      let(:stripe_token) { "garbled_stripe_token" }

      context "and valid credit card" do
        let(:stripe_response) { double(:stripe_response, successful?: true) }

        subject(:perform) do
          described_class.perform(user: user,
                                  stripe_token: stripe_token,
                                  invitation_token: nil)
        end

        after { ActionMailer::Base.deliveries.clear }

        it "creates new user" do
          expect { perform }.to change { User.count }.by 1
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
          let(:invitation_token) { "valid_invitation_token" }

          subject(:perform) do
            described_class.perform(user: user,
                                    stripe_token: stripe_token,
                                    invitation_token: invitation_token)
          end

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
        let(:stripe_response) do
          double(:stripe_response,
                 successful?: false,
                 error_message: "Your card was declined.")
        end

        subject(:perform) do
          described_class.perform(user: user,
                                  stripe_token: stripe_token,
                                  invitation_token: nil)
        end

        it "does not create a new user" do
          expect { perform }.to_not change { User.count }
        end

        it "sets the error message" do
          expect(perform.error_message).to eq "Your card was declined."
        end
      end
    end

    context "with invalid personal information" do
      let(:user) do
        Fabricate.build(:user, fullname: "Lookmaa Noemail", email: nil)
      end

      subject(:perform) do
        described_class.perform(user: user,
                                stripe_token: "doesnt_matter",
                                invitation_token: nil)
      end

      it "does not save the new user" do
        expect { perform }.to_not change { User.count }
      end

      it "does not attempt to charge the credit card" do
        allow(StripeWrapper::Charge).to receive(:create)
        perform
        expect(StripeWrapper::Charge).to_not have_received(:create)
      end

      it "does not send out the welcome email" do
        perform
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

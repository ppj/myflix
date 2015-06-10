require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name("User") }
  it { should validate_presence_of(:invitee_name) }
  it { should validate_presence_of(:invitee_email) }
  it { should validate_presence_of(:message) }

  it "should have a token" do
    invitation = Fabricate :invitation
    expect(invitation.token).to be_present
  end
end

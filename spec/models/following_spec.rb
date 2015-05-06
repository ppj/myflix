require 'spec_helper'

describe Following do
  it { should belong_to(:follower).class_name("User") }
  it { should belong_to(:followed).class_name("User") }
  it { should validate_presence_of(:follower_id) }
  it { should validate_presence_of(:followed_id) }
  it { should validate_uniqueness_of(:follower_id).scoped_to(:followed_id) }

  describe "#cannot_follow_self" do
    let(:bob) { Fabricate :user }
    before { @following = Following.create(follower: bob, followed: bob) }

    it "does not create a Following" do
      expect(Following.count).to eq(0)
    end

    it "includes an error on the object" do
      expect(@following.valid?).to be_falsey
      expect(@following.errors.full_messages).to include("You cannot follow yourself")
    end
  end
end

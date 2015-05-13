require 'spec_helper'

describe User do
  it { should have_secure_password }
  it { should validate_length_of(:password).is_at_least(3) }
  it { should validate_length_of(:email).is_at_least(5) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_length_of(:fullname).is_at_least(2) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:queue_items).order(:position) }

  it { should have_many(:followings).with_foreign_key(:follower_id) }
  it { should have_many(:followeds).through(:followings) }

  it { should have_many(:inverse_followings).class_name("Following").with_foreign_key(:followed_id) }
  it { should have_many(:followers).through(:inverse_followings) }

  it "generates token before creating a new user" do
    bob = Fabricate :user
    expect(bob.token).to be_present
  end

  describe "#queued?" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "returns false if user has not queued the video" do
      expect(user.queued? video).to be false
    end

    it "returns true if user has queued the video" do
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(user.queued? video).to be true
    end
  end

  describe "#follows?" do
    let(:bob) { Fabricate :user }
    let(:nat) { Fabricate :user }

    it "returns true if this user is following another user" do
      Fabricate :following, follower: bob, followed: nat
      expect(bob.follows?(nat)).to be true
    end

    it "returns false if this user is not following another user" do
      expect(bob.follows?(nat)).to be_falsey
    end
  end

  describe "#can_follow?" do
    let(:bob) { Fabricate :user }
    let(:nat) { Fabricate :user }

    it "returns true if this user can follow another user" do
      expect(bob.can_follow?(nat)).to be true
    end

    it "returns false if this user is already following the other user" do
      Fabricate :following, follower: bob, followed: nat
      expect(bob.can_follow?(nat)).to be_falsey
    end

    it "returns false if this user is the same as the other user" do
      expect(bob.can_follow?(bob)).to be_falsey
    end
  end
end

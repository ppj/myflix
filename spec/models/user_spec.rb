require 'spec_helper'

describe User do
  it { should have_secure_password }

  it { should validate_length_of(:password).is_at_least(3) }

  it { should validate_length_of(:email).is_at_least(5) }

  it { should validate_uniqueness_of(:email) }

  it { should validate_length_of(:fullname).is_at_least(2) }

  it { should have_many(:reviews).order("created_at DESC") }

  it { should have_many(:queue_items).order(:position) }

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
end

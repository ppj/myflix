require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:user) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }
  it { should validate_numericality_of(:position).only_integer }

  describe "#video_title" do
    it "returns the title of the video"  do
      video = Fabricate(:video, title: 'Shawshank Redemption')
      queue_item = Fabricate(:queue_item, video: video, user: Fabricate(:user))
      expect(queue_item.video_title).to eq('Shawshank Redemption')
    end
  end

  describe "#rating" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video, title: 'Shawshank Redemption') }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

    it "returns the rating of the video by the current user" do
      review = Fabricate(:review, rating: 3, creator: user, video: video)
      expect(queue_item.rating).to eq(3)
    end

    it "returns nil if current user has not reviewed the video" do
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#category" do
    it "returns the category of the associated video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video, user: Fabricate(:user))
      expect(queue_item.category).to be(category)
    end
  end

  describe "#category_name" do
    it "returns the category name of the video" do
      hits = Fabricate(:category, name: 'All Time Hits')
      video = Fabricate(:video, title: 'Shawshank Redemption', category: hits)
      queue_item = Fabricate(:queue_item, video: video, user: Fabricate(:user))
      expect(queue_item.category_name).to eq('All Time Hits')
    end
  end

  describe "on additon of a new video in the user's queue" do
    let(:user) { Fabricate(:user) }

    it "sets the position to 1 for the first addtion" do
      queue_item = user.queue_items.create(video: Fabricate(:video))
      expect(queue_item.position).to eq(1)
    end

    it "sets the queue item's position to user's queue item count + 1" do
      user.queue_items.create(video: Fabricate(:video))
      queue_item = user.queue_items.create(video: Fabricate(:video))
      expect(queue_item.position).to eq(2)
    end
  end
end

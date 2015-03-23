require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order('created_at DESC') }

  describe '#search_by_title' do
    let!(:video1) { Video.create(title: 'How I Met Your Mother', description: 'Sitcom') }
    let!(:video2) { Video.create(title: 'Mother', description: 'Sitcom Sitcom') }

    it 'returns empty array if no video found' do
      expect(Video.search_by_title('family')).to eq([])
    end

    it 'returns array with one video for an exact match' do
      expect(Video.search_by_title('Met')).to eq([video1])
    end

    it 'returns array with one video for a partial match' do
      expect(Video.search_by_title('our')).to eq([video1])
    end

    it 'returns array with all matches ordered by created_at (descending)' do
      expect(Video.search_by_title('Mother')).to eq([video2, video1])
    end

    it 'returns an empty array when search string is blank' do
      expect(Video.search_by_title("    ")).to eq([])
    end
  end

  describe "#rating" do
    let(:test_video) { Fabricate(:video) }

    before do
      test_video.reviews.create(body: "This is just a sample review!", rating: 3, creator: Fabricate(:user))
    end

    it "returns the rating of the only review for that video" do
      expect(test_video.rating).to eq(3.0)
    end

    it "returns the average of the ratings of all reviews for that video" do
      test_video.reviews.create(body: "This is a superb video!", rating: 5, creator: Fabricate(:user))
      test_video.reviews.create(body: "This is a stupid video!", rating: 2, creator: Fabricate(:user))
      expect(test_video.rating).to eq(3.3)
    end

    it "returns nil if the video has no reviews"do
      test_video.reviews.create(body: "This is a superb video!", rating: 5)
      test_video.reviews.clear
      expect(test_video.rating).to be_nil
    end
  end
end

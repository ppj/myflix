require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order('created_at DESC') }

  describe '#search_by_title' do
    it 'returns empty array if no video found' do
      video = Video.create(title: 'How I Met Your Mother', description: 'Sitcom Sitcom')
      expect(Video.search_by_title('family')).to eq([])
    end

    it 'returns array with one video for an exact match' do
      video1 = Video.create(title: 'How I Met Your Mother', description: 'Sitcom')
      video2 = Video.create(title: 'Mother', description: 'Sitcom Sitcom')
      expect(Video.search_by_title('Met')).to eq([video1])
    end

    it 'returns array with one video for a partial match' do
      video1 = Video.create(title: 'How I Met Your Mother', description: 'Sitcom')
      video2 = Video.create(title: 'Mother', description: 'Sitcom Sitcom')
      expect(Video.search_by_title('our')).to eq([video1])
    end

    it 'returns array with all matches ordered by created_at (descending)' do
      video1 = Video.create(title: 'How I Met Your Mother', description: 'Sitcom', created_at: 1.day.ago)
      video2 = Video.create(title: 'Mother', description: 'Sitcom Sitcom')
      expect(Video.search_by_title('Mother')).to eq([video2, video1])
    end

    it 'returns an empty array when search string is blank' do
      video1 = Video.create(title: 'How I Met Your Mother', description: 'Sitcom', created_at: 1.day.ago)
      video2 = Video.create(title: 'Mother', description: 'Sitcom Sitcom')
      expect(Video.search_by_title("    ")).to eq([])
    end
  end

  describe "#update_rating!" do
    let(:test_video) { Fabricate(:video) }
    let(:current_user) { Fabricate(:user) }

    it "sets rating to the same as that of the only review" do
      test_video.reviews.create(body: "This is just a sample review!", rating: 3, creator: current_user)
      test_video.save
      expect(test_video.rating).to eq(3.0)
    end

    it "sets rating to the average of the ratings of all reviews" do
      test_video.reviews.create(body: "This is a superb video!", rating: 5, creator: current_user)
      test_video.reviews.create(body: "This is a stupid video!", rating: 2, creator: current_user)
      test_video.save
      expect(test_video.rating).to eq(3.5)
    end

    it "resets rating to nil after all (or only) reviews have been deleted"do
      test_video.reviews.create(body: "This is a superb video!", rating: 5)
      test_video.reviews.create(body: "This is a stupid video!", rating: 2)
      test_video.reviews.clear
      test_video.save
      expect(test_video.rating).to be_nil
    end
  end
end

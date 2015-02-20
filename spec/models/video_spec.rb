require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews) }
  it do
    should validate_numericality_of(:rating)
       .is_greater_than_or_equal_to(1)
  end
  it do
    should validate_numericality_of(:rating)
       .is_less_than_or_equal_to(5)
  end

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

  describe "#update_rating" do
    it "sets rating on creation of new video" do
      video1 = Fabricate(:video)
      expect(video1.rating).to eq(1.0)
    end
  end
end

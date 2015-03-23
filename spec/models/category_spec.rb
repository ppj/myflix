require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    let(:sitcoms) { Category.create(name: 'Sitcom') }

    it 'returns empty array when category does not exist' do
      expect(sitcoms.recent_videos).to eq([])
    end

    it 'returns array of videos in the category in reverse chronological order' do
      v1 = Video.create(title: 'Test1', description: 'V 1', category: sitcoms)
      v2 = Video.create(title: 'Test2', description: 'V 2', category: sitcoms)
      v3 = Video.create(title: 'Test3', description: 'V 3', category: sitcoms, created_at: 1.day.ago)
      expect(sitcoms.recent_videos).to eq([v2, v1, v3])
    end

    it 'returns all videos in category if less than 6' do
      v1 = Video.create(title: 'Test1', description: 'V 1', category: sitcoms)
      v2 = Video.create(title: 'Test2', description: 'V 2', category: sitcoms)
      expect(sitcoms.recent_videos.count).to eq(2)
    end

    it 'returns only 6 videos in the category that has more than 6 videos' do
      7.times {Video.create(title: 'test', description: 'testing times', category: sitcoms)}
      expect(sitcoms.recent_videos.count).to eq(6)
    end
  end
end

require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe '#recent_videos' do
    it 'returns empty array when category does not exist' do
      sitcoms = Category.create(name: 'Sitcom')
      v1 = Video.create(title: 'Test1', description: 'V 1', category: sitcoms)
      v2 = Video.create(title: 'Test2', description: 'V 2', category: sitcoms)
      v3 = Video.create(title: 'Test3', description: 'V 3', category: sitcoms)
      expect(Category.recent_videos("Drama")).to eq([])
    end

    it 'returns array of available (< 6) videos in the category by created_at (descending)' do
      sitcoms = Category.create(name: 'Sitcom')
      v1 = Video.create(title: 'Test1', description: 'V 1', category: sitcoms)
      v2 = Video.create(title: 'Test2', description: 'V 2', category: sitcoms)
      v3 = Video.create(title: 'Test3', description: 'V 3', category: sitcoms, created_at: 1.day.ago)
      expect(Category.recent_videos("Sitcom")).to eq([v2, v1, v3])
    end

    it 'returns array of latest 6 videos in the category by created_at (descending)' do
      sitcoms = Category.create(name: 'Sitcom')
      v1 = Video.create(title: 'Test1', description: 'V 1', category: sitcoms)
      v2 = Video.create(title: 'Test2', description: 'V 2', category: sitcoms)
      v3 = Video.create(title: 'Test3', description: 'V 3', category: sitcoms, created_at: 1.day.ago)
      v4 = Video.create(title: 'Test4', description: 'V 4', category: sitcoms)
      v5 = Video.create(title: 'Test5', description: 'V 5', category: sitcoms)
      v6 = Video.create(title: 'Test6', description: 'V 6', category: sitcoms)
      v7 = Video.create(title: 'Test7', description: 'V 7', category: sitcoms)
      expect(Category.recent_videos("Sitcom")).to eq([v7, v6, v5, v4, v2, v1])
    end

  end
end

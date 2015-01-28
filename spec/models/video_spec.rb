require 'spec_helper'

describe Video do
  it {should belong_to(:category)}

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:description) }

  describe '#search_by_title' do
    it 'cannot find videos by words in title' do
      video = Video.create(title: 'How I Met Your Mother', description: 'Sitcom Sitcom')
      expect(Video.search_by_title('family')).to eq([])
    end

    it 'finds videos by words in title' do
      video1 = Video.create(title: 'How I Met Your Mother', description: 'Sitcom')
      video2 = Video.create(title: 'Mother', description: 'Sitcom Sitcom')
      expect(Video.search_by_title('Mother')).to eq([video1, video2])
    end
  end

end

require 'spec_helper'

describe Video do
  it 'saves successfully' do
    video = Video.new(title: 'Test Video', description: 'Lorem Ipsum Dipsum Dimsum')
    video.save
    expect(Video.first).to eq(video)
  end

  it {should belong_to(:category)}

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:description) }

end

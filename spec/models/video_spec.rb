require 'spec_helper'

describe Video do
  it 'saves successfully' do
    video = Video.new(title: 'Test Video', description: 'Lorem Ipsum Dipsum Dimsum')
    video.save
    expect(Video.first.title).to eq('Test Video')
  end
end

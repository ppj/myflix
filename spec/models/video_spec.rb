require 'spec_helper'

describe Video do
  it 'saves successfully' do
    video = Video.new(title: 'Test Video', description: 'Lorem Ipsum Dipsum Dimsum')
    video.save
    expect(Video.first).to eq(video)
  end

  it 'belongs to a category' do
    cat = Category.create(name: 'TV Sitcom')
    video = Video.create(title: 'Big Bang Theory', description: 'A comedy series featuring a bunch of scientist-friends and their girlfriends.', category: cat)
    expect(video.category).to eq(cat)
  end
end

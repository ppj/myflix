require 'spec_helper'

describe Category do
  it 'saves successfully' do
    cat = Category.new(name: 'Drama')
    cat.save
    expect(Category.first).to eq(cat)
  end

  it 'has many videos' do
    cat = Category.create(name: 'TV Sitcom')
    vid1 = Video.create(title: 'Big Bang Theory', description: 'A comedy series featuring a bunch of scientist-friends and their girlfriends.', category: cat)
    vid2 = Video.create(title: 'Friends', description: 'A comedy series featuring a bunch of friends in NYC.', category: cat)
    expect(cat.videos).to include(vid1, vid2)
  end
end

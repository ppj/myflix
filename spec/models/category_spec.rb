require 'spec_helper'

describe Category do
  it 'saves successfully' do
    cat = Category.new(name: 'Drama')
    cat.save
    expect(Category.first).to eq(cat)
  end

  it 'has many videos' do
    vid1 = Video.create(title: 'Big Bang Theory', description: 'A comedy series featuring a bunch of scientist-friends and their girlfriends.')
    vid2 = Video.create(title: 'Friends', description: 'A comedy series featuring a bunch of friends in NYC.')
    cat = Category.create(name: 'TV Sitcom')
    cat.videos << vid1
    cat.videos << vid2
    # Some alternatives to the above
    # vid1.category_id = cat.id
    # vid1.save
    # vid2.category = cat
    # vid2.save
    expect(cat.videos).to eq([vid1, vid2])
  end
end

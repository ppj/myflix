require 'spec_helper'

describe Category do
  it 'saves successfully' do
    cat = Category.new(name: 'Drama')
    cat.save
    expect(Category.first).to eq(cat)
  end

  it { should have_many(:videos) }
end

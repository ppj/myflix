require 'spec_helper'

describe Review do
  it { should validate_inclusion_of(:rating).in_range(1..5) }
  it { should validate_length_of(:body).is_at_least(10) }
  it do
    should belong_to(:creator).
      class_name('User').
      with_foreign_key('user_id')
  end
  it { should belong_to(:video) }
  it "should update video rating after saving successfully" do
    test_video = Fabricate(:video)
    expect_any_instance_of(Video).to receive(:update_rating!).with(no_args)
    Review.create(Fabricate.attributes_for(:review, rating: 3, video: test_video))
  end
end

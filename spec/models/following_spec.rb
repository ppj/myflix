require 'spec_helper'

describe Following do
  it { should belong_to(:follower).class_name("User") }
  it { should belong_to(:followed).class_name("User") }
  it { should validate_presence_of(:follower_id) }
  it { should validate_presence_of(:followed_id) }
  it { should validate_uniqueness_of(:follower_id).scoped_to(:followed_id) }
end

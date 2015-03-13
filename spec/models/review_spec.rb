require 'spec_helper'

describe Review do
  it do
    should belong_to(:creator).
      class_name('User').
      with_foreign_key('user_id')
  end

  it { should belong_to(:video) }

  it { should validate_presence_of(:user_id) }

  it { should validate_presence_of(:video_id) }

  it { should validate_inclusion_of(:rating).in_range(1..5) }

  it { should validate_length_of(:body).is_at_least(10) }

  it { should validate_uniqueness_of(:user_id).scoped_to(:video_id) }
end

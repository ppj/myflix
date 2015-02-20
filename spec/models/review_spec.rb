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
end

require 'spec_helper'

describe Following do
  it { should belong_to(:follower).class_name("User") }
  it { should belong_to(:followed).class_name("User") }
end

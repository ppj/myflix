require 'spec_helper'

describe User do
  it { should have_secure_password }
  it { should ensure_length_of(:password).is_at_least(3) }
  it { should ensure_length_of(:email).is_at_least(5) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:fullname).is_at_least(2) }
end

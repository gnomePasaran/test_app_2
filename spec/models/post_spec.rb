require 'rails_helper'

RSpec.describe Post, type: :model do
  # it { should belong_to(:user) }
  # it { is_expected.to belong_to(:user) }
  it { should validate_presence_of(:text) }
  it { should validate_length_of(:text).is_at_least(3).is_at_most(140) }
end

require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to(:post) }
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:post_id).scoped_to(:user_id) }
end

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:likes) }
  it { should have_many(:posts) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_presence_of(:password) }
end

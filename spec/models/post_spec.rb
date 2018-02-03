require 'rails_helper'

RSpec.describe Post, type: :model do
  it { is_expected.to have_many(:likes) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:text) }
  it { is_expected.to validate_length_of(:text).is_at_most(140) }

  describe '.most_posting' do
    let!(:users) { create_list(:user, 5) }
    let!(:user) { create(:user) }
    before { users.map.with_index { |u, i| create_list(:post, i + 2, user: u) } }
    let(:result) { users.map { |u| { id: nil, user_id: u.id, count: u.posts.count } } }

    describe 'does not contains user' do
      it 'without posts' do
        expect(Post.most_posting).not_to include [user.id, user.posts.count]
      end

      it 'with lesser the 5th posts count' do
        create(:post, user: user)
        expect(Post.most_posting).not_to include [user.id, user.posts.count]
      end
    end

    it 'return most posting user' do
      expect(Post.most_posting.to_json).to eq result.reverse.to_json
    end
  end
end

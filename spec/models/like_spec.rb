require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to(:post) }
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:post_id).scoped_to(:user_id) }

  describe '.most_liked' do
    let!(:posts) { create_list(:post, 5) }
    let!(:post) { create(:post) }
    before { posts.map.with_index { |post, i| create_list(:like, i + 2, post: post) } }
    let(:result) { posts.map { |post| { id: nil, post_id: post.id, count: post.likes.count } } }

    it 'does not contains post without likes' do
      expect(Like.most_liked).to_not include [post.id, post.likes.count]
    end

    it 'does not contains post with lesser the 5th likes count' do
      create(:like, post: post)
      expect(Like.most_liked).to_not include [post.id, post.likes.count]
    end

    it 'return most liked post' do
      expect(Like.most_liked.to_json).to eq result.reverse.to_json
    end

    it "return most liked post's like count" do
      expect(Like.most_liked.to_json).to eq result.reverse.to_json
    end
  end
end

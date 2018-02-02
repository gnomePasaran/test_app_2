require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:likes) }
  it { should have_many(:posts) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_presence_of(:password) }

  describe '#average_rating' do
    let(:user) { create(:user) }
    let(:posts) { create_pair(:post, user: user) }
    before do
      create_list(:like, 5, post: posts.first)
      create(:like, post: posts.last)
    end

    it 'returns post rating' do
      likes_count = 0
      user.posts.map { |post| likes_count += post.likes.count }
      result = likes_count.to_f / user.posts.count.to_f

      expect(user.average_rating).to eq result
    end
  end

  describe '.most_posting_users' do
    let!(:users) { create_list(:user, 5) }
    let!(:user) { create(:user) }
    before { users.map.with_index { |u, i| create_list(:post, i + 2, user: u) } }
    let(:result) { users.map { |u| [u, u.posts.count] } }

    it 'does not contains user without posts' do
      expect(User.most_posting_users).to_not include [user, user.posts.count]
    end

    it 'does not contains user with lesser the 5th posts count' do
      create(:post, user: user)
      expect(User.most_posting_users).to_not include [user, user.posts.count]
    end

    it 'return most posting user' do
      expect(User.most_posting_users).to eq result.reverse
    end

    it "return most posting user's post count" do
      expect(User.most_posting_users).to eq result.reverse
    end
  end

  describe '.most_liked_users' do
    let!(:posts) { create_list(:post, 5) }
    let!(:post) { create(:post) }
    before { posts.map.with_index { |post, i| create_list(:like, i + 2, post: post) } }
    let(:result) { posts.map { |post| [post, post.user, post.likes.count] } }

    it 'does not contains post without likes' do
      expect(User.most_liked_users).to_not include [post, post.likes.count]
    end

    it 'does not contains post with lesser the 5th likes count' do
      create(:like, post: post)
      expect(User.most_liked_users).to_not include [post, post.likes.count]
    end

    it 'return most liked post' do
      expect(User.most_liked_users).to eq result.reverse
    end

    it "return most liked post's like count" do
      expect(User.most_liked_users).to eq result.reverse
    end
  end
end

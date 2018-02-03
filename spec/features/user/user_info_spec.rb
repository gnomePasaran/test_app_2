require_relative '../acceptance_helper'

describe 'To see Top-5 info for all time', '
  In order to see Top-5 in fofor all time
  As a guest
  I want to be able to see info for all time
' do

  let(:users) { create_list(:user, 5) }
  let(:user_without_posts) { create(:user) }

  before do
    users.map { |u| create(:post, user: u) }
    Post.all.map.with_index do |post, _i|
      users.map { |u| create(:like, user: u, post: post) unless post.user_id == u.id }
    end
    visit root_path
  end

  describe 'Guest try to see Top-5' do
    it 'the most posting users' do
      expect(page.has_content?(users.first.email)).to be(true)
      expect(page.has_content?(user_without_posts.email)).to be(false)
    end

    it 'count of posts of the most posting users' do
      expect(page.has_content?(users.first.posts.count)).to be(true)
    end
  end

  describe 'Guest try to see Top-5 users' do
    let(:most_liked_users) { User.most_liked_users }

    it 'with the most liked posts and posts itself' do
      expect(page.has_content?(most_liked_users.first[1].email)).to be(true)
      expect(page.has_content?(most_liked_users.first[0].text)).to be(true)
      expect(page.has_content?(most_liked_users.first[2])).to be(true)
    end
  end

  describe 'Guest try to see Top-5 users' do
    let(:most_average_users) { User.most_average_users }

    it 'with the most average rating' do
      expect(page.has_content?(most_average_users.first[0].email)).to be(true)
      expect(page.has_content?(most_average_users.first[1])).to be(true)
    end
  end
end

require_relative '../acceptance_helper'

describe 'To see Top-5 one day info', '
  In order to see Top-5 info
  As a guest
  I want to be able to see one day info
' do

  let(:users) { create_list(:user, 5, created_at: Time.current) }
  let(:week_ago_posted_user) { create(:user) }
  let(:week_ago_post) { create(:post, user: week_ago_posted_user, created_at: Time.current - 1.week) }

  before do
    users.map { |u| create(:post, user: u, created_at: Time.current) }
    Post.all.map.with_index do |post, _i|
      users.map { |u| create(:like, user: u, post: post, created_at: Time.current) unless post.user_id == u.id }
    end
    create_list(:like, 10, post: week_ago_post, created_at: Time.current - 1.week)
    visit day_info_path
  end

  describe 'Guest try to see Top-5' do
    it 'the most posting users' do
      expect(page.has_content?(users.first.email)).to be(true)
      expect(page.has_content?(week_ago_posted_user.email)).to be(false)
    end

    it 'count of posts of the most posting users' do
      expect(page.has_content?(users.first.posts.count)).to be(true)
    end

    it 'without week ago posting users' do
      expect(page.has_content?(week_ago_posted_user.email)).to be(false)
    end
  end

  describe 'Guest try to see Top-5 users' do
    let(:most_liked_users) { User.most_liked_users(Date.current, Date.current) }

    it 'with the most liked posts and posts itself' do
      expect(page.has_content?(most_liked_users.first[1].email)).to be(true)
      expect(page.has_content?(most_liked_users.first[0].text)).to be(true)
      expect(page.has_content?(most_liked_users.first[2])).to be(true)
    end

    it 'without week ago liked posts and posts itself' do
      expect(page.has_content?(week_ago_posted_user.email)).to be(false)
      expect(page.has_content?(week_ago_post.text)).to be(false)
      expect(page.has_content?('Likes: week_ago_post.likes.count')).to be(false)
    end
  end

  describe 'Guest try to see Top-5 users' do
    let(:most_average_users) { User.most_average_users(Date.current, Date.current) }
    let(:average_week_ago) { User.most_average_users(Date.current - 1.week, Date.current - 4.days) }

    it 'with the most average rating' do
      expect(page.has_content?(most_average_users.first[0].email)).to be(true)
      expect(page.has_content?(most_average_users.first[1])).to be(true)
    end

    it 'without week ago rating posts' do
      expect(page.has_content?(average_week_ago.first[0].email)).to be(false)
      expect(page.has_content?(average_week_ago.first[1])).to be(false)
    end
  end
end

require_relative '../acceptance_helper'

describe 'To see Top-5 one day info', '
  In order to see Top-5 info
  As a guest
  I want to be able to see one day info
' do

  let(:users) { create_list(:user, 5, created_at: Time.current - 4.days) }
  let(:month_ago_posted_user) { create(:user) }
  let(:month_ago_post) { create(:post, user: month_ago_posted_user, created_at: Time.current - 1.month) }

  before do
    users.map { |u| create(:post, user: u, created_at: Time.current - 4.days) }
    Post.all.map.with_index do |post, _i|
      users.map { |u| create(:like, user: u, post: post, created_at: Time.current - 4.days) unless post.user_id == u.id }
    end
    create_list(:like, 10, post: month_ago_post, created_at: Time.current - 1.month)
    visit week_info_path
  end

  describe 'Guest try to see Top-5' do
    it 'the most posting users' do
      expect(page.has_content?(users.first.email)).to be(true)
      expect(page.has_content?(month_ago_posted_user.email)).to be(false)
    end

    it 'count of posts of the most posting users' do
      expect(page.has_content?(users.first.posts.count)).to be(true)
    end

    it 'without month ago posting users' do
      expect(page.has_content?(month_ago_posted_user.email)).to be(false)
    end
  end

  describe 'Guest try to see Top-5 users' do
    let(:most_liked_users) { User.most_liked_users(Date.current - 1.week, Date.current) }

    it 'with the most liked posts and posts itself' do
      expect(page.has_content?(most_liked_users.first[1].email)).to be(true)
      expect(page.has_content?(most_liked_users.first[0].text)).to be(true)
      expect(page.has_content?(most_liked_users.first[2])).to be(true)
    end

    it 'without month ago liked posts and posts itself' do
      expect(page.has_content?(month_ago_posted_user.email)).to be(false)
      expect(page.has_content?(month_ago_post.text)).to be(false)
      expect(page.has_content?(month_ago_post.likes.count)).to be(false)
    end
  end

  describe 'Guest try to see Top-5 users' do
    let(:most_average_users) { User.most_average_users(Date.current, Date.current - 1.week) }
    let(:average_week_ago) { User.most_average_users(Date.current - 1.month, Date.current - 2.weeks) }

    it 'with the most average rating' do
      expect(page.has_content?(most_average_users.first[0].email)).to be(true)
      expect(page.has_content?(most_average_users.first[1])).to be(true)
    end

    it 'without month ago rating posts' do
      expect(page.has_content?(average_week_ago.first[0].email)).to be(false)
      expect(page.has_content?(average_week_ago.first[1])).to be(false)
    end
  end
end

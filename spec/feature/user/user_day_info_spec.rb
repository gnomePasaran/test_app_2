require_relative '../acceptance_helper'

feature 'To see Top-5 one day info', %q{
  In order to see Top-5 info
  As a guest
  I want to be able to see one day info
} do

  given(:users) { create_list(:user, 5, created_at: Time.current) }
  given(:week_ago_posted_user) { create(:user) }
  given(:week_ago_post) { create(:post, user: week_ago_posted_user, created_at: Time.current - 1.week) }

  background do
    users.map { |u| create(:post, user: u, created_at: Time.current) }
    Post.all.map.with_index do |post, i|
      users.map { |u| create(:like, user: u, post: post, created_at: Time.current) unless post.user_id == u.id }
    end
    create_list(:like, 10, post: week_ago_post, created_at: Time.current - 1.week)
    visit day_info_path
  end

  describe 'Guest try to see Top-5' do
    scenario 'the most posting users' do
      expect(page).to have_content users.first.email
      expect(page).to_not have_content week_ago_posted_user.email
    end

    scenario 'count of posts of the most posting users' do
      expect(page).to have_content users.first.posts.count
    end

    scenario 'without week ago posting users' do
      expect(page).to_not have_content week_ago_posted_user.email
    end
  end

  describe 'Guest try to see Top-5 users' do
    given(:most_liked_users) { User.most_liked_users(Date.current, Date.current) }
    scenario 'with the most liked posts and posts itself' do
      expect(page).to have_content most_liked_users.first[1].email
      expect(page).to have_content most_liked_users.first[0].text
      expect(page).to have_content most_liked_users.first[2]
    end

    scenario 'without week ago liked posts and posts itself' do
      expect(page).to_not have_content week_ago_posted_user.email
      expect(page).to_not have_content week_ago_post.text
      expect(page).to_not have_content week_ago_post.likes.count
    end
  end

  describe 'Guest try to see Top-5 users' do
    given(:most_average_users) { User.most_average_users(Date.current, Date.current) }
    given(:average_week_ago) { User.most_average_users(Date.current - 1.week, Date.current - 4.days) }
    scenario 'with the most average rating' do
      expect(page).to have_content most_average_users.first[0].email
      expect(page).to have_content most_average_users.first[1]
    end

    scenario 'without week ago rating posts' do
      expect(page).to_not have_content average_week_ago.first[0].email
      expect(page).to_not have_content average_week_ago.first[1]
    end
  end
end

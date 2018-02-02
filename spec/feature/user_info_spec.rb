require_relative './acceptance_helper'

feature 'To see Top-5 info', %q{
  In order to see Top-5 info
  As a guest
  I want to be able to see info
} do

  given(:users) { create_list(:user, 5) }
  given(:user_without_posts) { create(:user) }

  background do
    users.map { |u| create(:post, user: u) }
    Post.all.map.with_index do |post, i|
      users.map { |u| create(:like, user: u, post: post) unless post.user_id == u.id }
    end
    visit root_path
  end

  describe 'Guest try to see Top-5' do
    scenario 'the most posting users' do
      expect(page).to have_content users.first.email
      expect(page).to_not have_content user_without_posts.email
    end

    scenario 'count of posts of the most posting users' do
      expect(page).to have_content users.first.posts.count
    end
  end

  describe 'Guest try to see Top-5 users' do
    given(:most_liked_users) { User.most_liked_users }
    scenario 'with the most liked posts and posts itself' do
      expect(page).to have_content most_liked_users.first[1].email
      expect(page).to have_content most_liked_users.first[0].text
      expect(page).to have_content most_liked_users.first[2]
    end
  end

  describe 'Guest try to see Top-5 users' do
    given(:most_average_users) { User.most_average_users }
    scenario 'with the most average rating' do
      expect(page).to have_content most_average_users.first[0].email
      expect(page).to have_content most_average_users.first[1]
    end
  end
end

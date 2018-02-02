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
  end

  scenario 'Guest try to see Top-5 most posting users' do
    visit root_path
    expect(page).to have_content users.first.email
    expect(page).to_not have_content user_without_posts.last.email
  end
end

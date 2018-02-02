class UsersController < ApplicationController
  def index
    @top_posts = User.most_posting_users
    @top_likes = User.most_liked_users
    @top_average = User.most_average_users

    respond_with @top_users
  end
end

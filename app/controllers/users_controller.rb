class UsersController < ApplicationController
  def index
    respond_with prepare_data
  end

  def day_info
    day = Date.current
    prepare_data(day, day)

    render :index
  end

  def week_info
    day = Date.current
    prepare_data(day - 1.week, day)

    render :index
  end

  private

  def prepare_data(from = nil, to = nil)
    @top_posts = User.most_posting_users(from, to)
    @top_likes = User.most_liked_users(from, to)
    @top_average = User.most_average_users(from, to)
  end
end

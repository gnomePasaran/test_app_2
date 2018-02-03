class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :likes
  has_many :posts

  def self.most_posting_users(from = nil, to = nil)
    Post.most_posting(from, to).map { |post| [User.find(post[:user_id]), post[:count]] }
  end

  def self.most_liked_users(from = nil, to = nil)
    Like.most_liked(from, to).map { |like| [post = Post.find(like[:post_id]), User.find(post.user_id), like[:count]] }
  end

  def self.most_average_users(from = nil, to = nil)
    User.all.map { |u| [u, u.average_rating(from, to)] } .sort_by { |e| -e[1] } .first(5)
  end

  def average_rating(from = nil, to = nil)
    likes_count = 0

    posts = self.posts
    posts = self.posts.where('created_at between ? and ?', from, to.to_date + 1.day) if from.present? && to.present?
    posts.map do |post|
      likes = post.likes
      likes = likes.where('created_at between ? and ?', from, to.to_date + 1.day) if from.present? && to.present?
      likes_count += likes.count
    end

    result = likes_count.to_f / posts.count.to_f
    result = 0 if posts.count == 0
    result
  end
end

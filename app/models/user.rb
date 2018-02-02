class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :likes
  has_many :posts

  scope :most_posting_users, -> { Post.most_posting.map { |post| [User.find(post[0]), post[1]]} }
  scope :most_liked_users, -> do
    Like.most_liked.map { |like| [post = Post.find(like[0]), User.find(post.user_id), like[1]] }
  end
  scope :most_average_users, -> do
    User.all.map { |u| [u, u.average_rating] } .sort_by { |e| -e[1] } .first(5)
  end

  def average_rating
    likes_count = 0
    posts.map { |post| likes_count += post.likes.count }
    likes_count.to_f / posts.count.to_f
  end
end

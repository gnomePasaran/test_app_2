class Post < ApplicationRecord
  belongs_to :user

  has_many :likes

  validates :text, presence: true
  validates :text, length: { maximum: 140 }

  scope :most_posting, -> {
    select('user_id, count(user_id)').group('user_id').order('count(user_id) desc').pluck('user_id, count(user_id)').first(5)
  }
end

class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :post_id, uniqueness: { scope: :user_id }

  scope :most_liked, -> do
    select('post_id, count(post_id)').group('post_id').order('count(post_id) desc').pluck('post_id, count(post_id)').first(5)
  end
end

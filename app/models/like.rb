class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :post_id, uniqueness: { scope: :user_id }

  def self.most_liked(from = nil, to = nil)
    find_by_sql("
      select post_id, count(post_id) from likes
      #{"where created_at between '" + from.to_s + "' and '" + (to.to_date + 1.day).to_s + "'" if from.present? && to.present? }
      group by post_id order by count(post_id) desc limit 5
    ")
  end
end

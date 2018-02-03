class Post < ApplicationRecord
  belongs_to :user

  has_many :likes

  validates :text, presence: true
  validates :text, length: { maximum: 140 }

  def self.most_posting(from = nil, to = nil)
    find_by_sql("
      select user_id, count(user_id) from posts
      #{"where created_at between '" + from.to_s + "' and '" + (to.to_date + 1.day).to_s + "'" if from.present? && to.present? }
      group by user_id order by count(user_id) desc limit 5
    ")
  end
end

class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :text, :likes

  def likes
    object.likes.count
  end
end

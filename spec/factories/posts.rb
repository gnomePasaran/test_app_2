FactoryBot.define do
  factory :post do
    user
    text 'Some text'
  end
  factory :invalid_post, class: Post do
    text ''
  end
end

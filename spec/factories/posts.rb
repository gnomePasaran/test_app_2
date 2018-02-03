FactoryBot.define do
  sequence :text do |n|
    "Some text#{n}"
  end
  factory :post do
    user
    text
  end
  factory :invalid_post, class: Post do
    text { 'a' * 150 }
  end
end

FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag #{n}" }
    association :user
  end
end

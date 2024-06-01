FactoryBot.define do
  factory :collection do
    name { "Sample Collection" }
    description { "This is a sample collection." }
    topic { "Default Topic" }
    user { create(:user) }
  end
end

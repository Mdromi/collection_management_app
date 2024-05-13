FactoryBot.define do
  factory :collection do
    name { "Sample Collection" }
    description { "This is a sample collection." }
    topic { "Default Topic" }
    user # This will automatically create a user association for the collection
  end
end

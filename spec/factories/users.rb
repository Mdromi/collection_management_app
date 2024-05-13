FactoryBot.define do
  factory :user do
    username { "example_user" }
    email { "user@example.com" }
    password { "password" }
    # Add any other attributes you want to set for the user
  end
end

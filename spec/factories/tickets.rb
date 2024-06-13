FactoryBot.define do
  factory :ticket do
    user { nil }
    summary { "MyString" }
    priority { "MyString" }
    jira_ticket_url { "MyString" }
    status { "MyString" }
  end
end

FactoryBot.define do
  factory :item_custom_field_value do
    item { nil }
    custom_field { nil }
    value { "MyString" }
  end
end

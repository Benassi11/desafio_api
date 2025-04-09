FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    status { 1 }
    estimated_time { "2025-04-08" }
    user { nil }
  end
end

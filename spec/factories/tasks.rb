FactoryBot.define do
  factory :task do
    title { "Titletest" }
    description { "Descriptiontest" }
    status { 1 }
    estimated_time { "2025-04-08" }
    user { association :user }
  end
end

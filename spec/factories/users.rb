FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    is_admin { false }

    trait :user_admin do
      is_admin { true }
    end

    trait :user_task do
      task { association :task }
    end
    
    trait :user_admin_task do
      is_admin { true }
      task { association :task }
    end
  end
end
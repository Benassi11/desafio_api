FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '123123' }
    password_confirmation { '123123' }
    is_admin { false }

    trait :user_admin do
      is_admin { true }
    end
  end
end
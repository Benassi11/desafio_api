FactoryBot.define do
  factory :comment do
    description { "Descriptiontest" }
    user { association :user }
    task { association :task }

    trait :comment_parent do
      parent { association :comment }
      replies { [association(:comment), association(:comment)] } 
    end
  end
end
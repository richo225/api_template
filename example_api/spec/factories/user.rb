FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@mail.com" }
    password { 'StrongPassword3' }
  end
end

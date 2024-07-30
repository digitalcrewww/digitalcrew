FactoryBot.define do
  factory :user do
    username { "MyString" }
    email { "MyString" }
    password_digest { "MyString" }
    is_accepted { false }
  end
end

FactoryBot.define do
  factory :user do
    name { "name" }
    email { "email@mail.com" }
    cpf { "112.780.954-70" }
    password { "abc123" }
  end
end

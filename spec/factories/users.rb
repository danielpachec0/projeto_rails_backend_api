FactoryBot.define do
  factory :user do
    name { "name" }
    email { "email@mail.com" }
    cpf { "075.494.884-60" }
    password { "abc123" }
  end
end

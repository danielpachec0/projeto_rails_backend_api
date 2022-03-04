FactoryBot.define do
  factory :answer do
    content { "answer text" }
    answered_at { "2022-03-03 14:25:55" }
    formulary factory: :formulary
    question factory: :question
    association :visit
  end
end

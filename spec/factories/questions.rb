FactoryBot.define do
  factory :question do
    name { "name" }
    formulary
    trait :text do
      question_type { "text" }
      text {"A big text"}
    end
    trait :image do
      question_type { "image" }
      image { Rack::Test::UploadedFile.new "#{Rails.root}/spec/fixtures/files/image.png" }
    end
  end
end

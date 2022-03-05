class Question < ApplicationRecord
    has_one_attached :image

    validates :name, uniqueness: {  scope: :formulary_id,
                                    message: "uniquennes msg placeholder"}
    validates :question_type, inclusion: { in: ['image', 'text'],
                                    message: "%{value} is not a valid option for question_type"}
    with_options if: :is_image? do |img|
        img.validates :image, attached: true
        img.validates :text, absence: true
    end
    with_options unless: :is_image? do |img|
        img.validates :image, absence: true
        img.validates :text, presence: true
    end
    

    

    belongs_to :formulary
    has_one :answer

    def is_image?
        question_type == 'image'
    end 
end

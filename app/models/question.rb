class Question < ApplicationRecord
    validates :name, uniqueness: {  scope: :formulary_id,
                                    message: "uniquennes msg placeholder"}
    
    has_one_attached :image

    belongs_to :formulary
    has_one :answer
end

class Answer < ApplicationRecord
    validates :formulary_id, :question_id, presence: true
    
    belongs_to :question
    belongs_to :formulary
    belongs_to :visit
end

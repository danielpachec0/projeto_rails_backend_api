class Answer < ApplicationRecord
    acts_as_paranoid
    
    validates :formulary_id, :question_id, presence: true
    validate :check_if_question_belong_to_form, 
    unless: -> {
        Question.find_by(id: question_id).nil? || 
        Formulary.find_by(id: formulary_id).nil? 
    }
        
    belongs_to :question
    belongs_to :formulary
    belongs_to :visit, optional: true

    private
      
    def check_if_question_belong_to_form
        id_to_check = Question.find_by(id: question_id)["formulary_id"]

        if formulary_id != id_to_check
            errors.add(:date, "The Question must be from the same formulary")
        end
    end 
end

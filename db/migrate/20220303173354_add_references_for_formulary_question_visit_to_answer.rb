class AddReferencesForFormularyQuestionVisitToAnswer < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :formulary, null: false, foreign_key: true
    add_reference :answers, :question, null: false, foreign_key: true
    add_reference :answers, :visit, null: true, foreign_key: true
  end
end

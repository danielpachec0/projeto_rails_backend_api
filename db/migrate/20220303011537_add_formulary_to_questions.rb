class AddFormularyToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :formulary, null: false, foreign_key: true
  end
end

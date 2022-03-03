class RenameQuestionColumnTypeToQuestionType < ActiveRecord::Migration[7.0]
  def change
    remove_column :questions, :type
    add_column :questions, :question_type, :string
  end
end

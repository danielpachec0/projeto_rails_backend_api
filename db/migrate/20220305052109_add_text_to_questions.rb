class AddTextToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :text, :text
  end
end

class CreateAnswerChoices < ActiveRecord::Migration[7.0]
  def change
    create_table :answer_choices do |t|
      t.references :question, null:false, foreign_key:true
      t.string :text, null:false
      t.timestamps
    end
  end
end

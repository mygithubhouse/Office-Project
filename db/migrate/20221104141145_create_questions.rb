class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
    	t.integer :question_type, null: false
    	t.integer :answer_type, null: false,  :default => 0
    	t.text :options, array: true
    	t.string :content, null: false
    	t.timestamps
    end
  end
end

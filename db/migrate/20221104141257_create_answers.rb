class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
    	t.string :question_id
    	t.string :account_id
    	t.string :content
    	t.timestamps
    end
  end
end

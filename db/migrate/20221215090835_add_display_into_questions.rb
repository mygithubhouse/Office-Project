class AddDisplayIntoQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :display, :integer, :default => 0, null: false
  end
end

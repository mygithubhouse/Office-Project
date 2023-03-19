class CreateEasyModes < ActiveRecord::Migration[6.0]
  def change
    create_table :easy_modes do |t|
      t.integer :nights_ahead
      t.time :easy_prompt_time
      t.time :second_easy_prompt_time
      t.boolean :active, default: true

      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end

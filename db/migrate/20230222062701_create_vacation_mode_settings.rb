class CreateVacationModeSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :vacation_mode_settings do |t|
      t.datetime :vacation_begin
      t.datetime :vacation_end
      t.integer  :default_commitment
      t.boolean  :active, default: true

      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end

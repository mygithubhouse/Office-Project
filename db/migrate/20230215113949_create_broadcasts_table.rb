class CreateBroadcastsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcasts do |t|
      t.datetime :scheduled_date
      t.string :message
      t.integer :account_ids, array: true, default: []
      t.string :jid
      t.timestamps
    end
  end
end

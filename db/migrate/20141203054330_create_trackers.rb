class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :date
      t.string :time_in
      t.string :time_out
      t.integer :user_id

      t.timestamps
    end
  end
end

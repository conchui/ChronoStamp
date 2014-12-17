class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.integer :user_id
      t.integer :project_id
      t.integer :assigned_person

      t.timestamps
    end
  end
end

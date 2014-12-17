class CreateProjectMakers < ActiveRecord::Migration
  def change
    create_table :project_makers do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
